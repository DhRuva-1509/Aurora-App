//
//  Transcriber.swift
//  Aurora
//
//  Created by Dhruva Patil on 2025-11-16.
//

import Foundation
import SwiftUI
import Speech


class Transcriber {
    
    let transcriptionResults: any AsyncSequence<SpeechTranscriber.Result, any Error>
    
    let analyzer: SpeechAnalyzer
    let transcriber: SpeechTranscriber
    var bestAvailableAudioFormat: AVAudioFormat? = nil
    var inputStream: AsyncStream<AnalyzerInput>? = nil
    var inputContinuation: AsyncStream<AnalyzerInput>.Continuation? = nil
    let preset: SpeechTranscriber.Preset = .timeIndexedProgressiveTranscription
    let locale: Locale
    var audioConverter: AVAudioConverter?
    
    init(locale: Locale) async throws {
        
        guard SpeechTranscriber.isAvailable else {
            throw _Error.notAvailable
        }
        
        transcriber = SpeechTranscriber(
            locale: locale,
            transcriptionOptions: self.preset.transcriptionOptions,
            reportingOptions: self.preset.reportingOptions.union([.alternativeTranscriptions]),
            attributeOptions: self.preset.attributeOptions.union([.transcriptionConfidence])
        )
        transcriptionResults = transcriber.results
        analyzer = SpeechAnalyzer(modules: [transcriber], options: .init(priority: .userInitiated, modelRetention: .processLifetime))
        
        self.bestAvailableAudioFormat = await SpeechAnalyzer.bestAvailableAudioFormat(compatibleWith: [transcriber])
        self.locale = locale
        
        let installed = (await SpeechTranscriber.installedLocales).contains(locale)
        if !installed {
            
            if let installationRequest = try await AssetInventory.assetInstallationRequest(supporting: [transcriber]) {
                try await installationRequest.downloadAndInstall()
            }
        }
    }
    
    deinit {
        Task { [weak self] in
            await self?.finishAnalysisSession()
        }
    }
    
    func finishAnalysisSession() async {
        self.inputContinuation?.finish()
        
      
        await self.analyzer.cancelAndFinishNow()
            
        
        await AssetInventory.release(reservedLocale: self.locale)

    }
    
    func startRealTimeTranscription() async throws {
        print(#function)
        
        try await self.finalizePreviousTranscribing()

        (inputStream, inputContinuation) = AsyncStream<AnalyzerInput>.makeStream()
        
        try await analyzer.start(inputSequence: inputStream!)
    }
    
    func streamAudioToTranscriber(_ buffer: AVAudioPCMBuffer) {
        
        let format: AVAudioFormat = self.bestAvailableAudioFormat ?? buffer.format
        
       
        var convertedBuffer: AVAudioPCMBuffer = buffer
        
        do {
            convertedBuffer = try self.convertBuffer(buffer, to: format)
        } catch(let error) {
            print("error converting buffer: \(error)")
        }
        
        let input: AnalyzerInput = AnalyzerInput(buffer: convertedBuffer)
        self.inputContinuation?.yield(input)
    }
    
    func convertBuffer(_ buffer: AVAudioPCMBuffer, to format: AVAudioFormat) throws -> AVAudioPCMBuffer {
        let inputFormat = buffer.format
        
        guard inputFormat != format else {
            return buffer
        }
        
        if audioConverter == nil || audioConverter?.outputFormat != format {
            audioConverter = AVAudioConverter(from: inputFormat, to: format)
            audioConverter?.primeMethod = .none // Sacrifice quality of first samples in order to avoid any timestamp drift from source
        }
        
        guard let audioConverter = audioConverter else {
            throw _Error.audioConverterCreationFailed
        }
        
        let sampleRateRatio = audioConverter.outputFormat.sampleRate / audioConverter.inputFormat.sampleRate
        let scaledInputFrameLength = Double(buffer.frameLength) * sampleRateRatio
        let frameCapacity = AVAudioFrameCount(scaledInputFrameLength.rounded(.up))
        guard let conversionBuffer = AVAudioPCMBuffer(pcmFormat: audioConverter.outputFormat, frameCapacity: frameCapacity) else {
            throw _Error.failedToConvertBuffer("Failed to create AVAudioPCMBuffer.")
        }
        
        var nsError: NSError?
        var bufferProcessed = false
        
        let status = audioConverter.convert(to: conversionBuffer, error: &nsError) { packetCount, inputStatusPointer in
            defer { bufferProcessed = true }
            // This closure can be called multiple times, but it only offers a single buffer.
            inputStatusPointer.pointee = bufferProcessed ? .noDataNow : .haveData
            return bufferProcessed ? nil : buffer
        }
        
        guard status != .error else {
            throw _Error.failedToConvertBuffer(nsError?.localizedDescription)
        }
        
        return conversionBuffer
    }
    
    func finalizePreviousTranscribing() async throws {
        self.inputContinuation?.finish()
        self.inputStream = nil
        self.inputContinuation = nil
        
        try await self.analyzer.finalize(through: nil)
    }
    
    enum _Error: Error {
        case notAvailable
        
        case audioConverterCreationFailed
        case failedToConvertBuffer(String?)

        var message: String {
            return switch self {
                
            case .notAvailable:
                "Transcriber is not available on the given device."
            
            case .audioConverterCreationFailed:
                "Fail to create Audio Converter"
            case .failedToConvertBuffer(let s):
                "Failed to convert buffer to the destination format. \(s, default: "")"
            }
        }
    }
}
