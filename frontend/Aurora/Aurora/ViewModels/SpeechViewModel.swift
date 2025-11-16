//
//  SpeechViewModel.swift
//  Aurora
//

import Foundation
import Speech
import AVFAudio
import Combine

@MainActor
final class SpeechViewModel: ObservableObject {
    
    private var capturer: AudioCapturer?
    private var transcriber: Transcriber?
    
    private var captureTask: Task<Void, Never>?
    private var transcriptionTask: Task<Void, Never>?
    
    @Published var volatileTranscript: String = ""
    @Published var finalizedTranscript: String = ""
    @Published var backendResponse: String = ""
    @Published var isRecording = false
    
    // MARK: - Public API
    
    func startRecording() {
        finalizedTranscript = ""
        volatileTranscript = ""
        backendResponse = ""
        
        print("startRecording()")
        
        Task { [weak self] in
            await self?._startRecording()
        }
    }
    
    func stopRecording() {
        print("stopRecording()")
        
        // Stop tasks
        captureTask?.cancel()
        transcriptionTask?.cancel()
        
        // Stop mic
        capturer?.stopCapturing()
        
        // Finish transcriber
        Task { [weak transcriber] in
            await transcriber?.finishAnalysisSession()
        }
        
        isRecording = false
        volatileTranscript = ""
        
        // SEND FULL TEXT TO API
        let textToSend = finalizedTranscript
        
        Task {
            do {
                print("📡 Sending final transcript to backend...")
                let response = try await ApiService.shared.sendTranscript(textToSend)
                
                await MainActor.run {
                    self.backendResponse = response
                }
                
                print("Backend Response:", response)
                
            } catch {
                print("API Error:", error)
            }
        }
    }
    
    // MARK: - Internal
    
    private func _startRecording() async {
        do {
            // 1. Create transcriber
            let transcriber = try await Transcriber(locale: Locale(identifier: "en-US"))
            self.transcriber = transcriber
            try await transcriber.startRealTimeTranscription()
            print("🎙 Transcriber Ready")
            
            // 2. Start microphone capture
            let capturer = try AudioCapturer()
            self.capturer = capturer
            try await capturer.startCapturingInput()
            print("🎤 Mic Audio Engine Started")
            
            isRecording = true
            
            // 3. MIC → Transcriber pipeline
            captureTask = Task { [weak transcriber, weak self] in
                guard let transcriber, let self, let capturer = self.capturer else { return }
                
                for await (buffer, _) in capturer.inputTapEventsStream {
                    transcriber.streamAudioToTranscriber(buffer)
                }
            }
            
            // 4. Transcriber → UI pipeline
            transcriptionTask = Task { [weak self, weak transcriber] in
                guard let self, let transcriber else { return }
                
                do {
                    for try await result in transcriber.transcriptionResults {
                        
                        // Extract plain text
                        let attributed = result.text
                        let plain = String(attributed.characters)
                        
                        if result.isFinal {
                            // Final text → accumulate
                            await MainActor.run {
                                if self.finalizedTranscript.isEmpty {
                                    self.finalizedTranscript = plain
                                } else {
                                    self.finalizedTranscript += " " + plain
                                }
                                self.volatileTranscript = ""
                            }
                        } else {
                            // Live text
                            await MainActor.run {
                                self.volatileTranscript = plain
                            }
                        }
                    }
                } catch {
                    print("Transcriber error:", error)
                }
            }
            
        } catch {
            print("Failed:", error)
            isRecording = false
        }
    }
}
