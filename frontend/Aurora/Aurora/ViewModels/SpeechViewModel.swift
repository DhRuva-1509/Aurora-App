//
//  SpeechViewModel.swift
//  Aurora
//
//  Created by Dhruva Patil on 2025-11-16.
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
    @Published var isRecording = false
    
    // MARK: - Public API
    
    func startRecording() {
        finalizedTranscript = ""
        volatileTranscript = ""
        print("startRecording()")
        
        Task { [weak self] in
            await self?._startRecording()
        }
    }
    
    func stopRecording() {
        print("stopRecording()")
        
        captureTask?.cancel()
        transcriptionTask?.cancel()
        
        capturer?.stopCapturing()
        
        Task { [weak transcriber] in
            await transcriber?.finishAnalysisSession()
        }
        
        isRecording = false
        volatileTranscript = ""
        // keep finalized if you want history
    }
    
    // MARK: - Private internal function
    
    private func _startRecording() async {
        do {
            // 1. Transcriber
            let transcriber = try await Transcriber(locale: Locale(identifier: "en-US"))
            self.transcriber = transcriber
            
            try await transcriber.startRealTimeTranscription()
            print("🎙 Transcriber Ready")
            
            // 2. Microphone Capturer
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
                        
                        // Extract pure text only (no metadata!)
                        let attributed = result.text
                        let plain = String(attributed.characters)

                        
                        if result.isFinal {
                            // FINALIZED TEXT
                            await MainActor.run {
                                if self.finalizedTranscript.isEmpty {
                                    self.finalizedTranscript = plain
                                } else {
                                    self.finalizedTranscript += " " + plain
                                }
                                self.volatileTranscript = ""
                            }
                        } else {
                            // VOLATILE TEXT
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
