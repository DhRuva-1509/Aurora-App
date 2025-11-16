//
//  RecordingStateModel.swift
//  Aurora
//
//  Created by Dhruva Patil on 2025-11-15.
//

import Foundation

/// Represents the current state of the recording/transcription process
enum RecordingStateModel: Equatable {
    case idle   //Not doing anything
    case requestingPermission   //Asking user for permission
    case ready  // Ready to start recording
    case recording  //Currently recording and transcribing
    case processing // Stopped recording, finalizing transcription
    case completed  // Transcription finished
    case error(String) //Something went wrong
    
    // MARK: - Equatable Conformance
    
    /// Custom equality implementation to handle the error case with associated value
    static func == (lhs: RecordingStateModel, rhs: RecordingStateModel) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.requestingPermission, .requestingPermission):
            return true
        case (.ready, .ready):
            return true
        case (.recording, .recording):
            return true
        case (.processing, .processing):
            return true
        case (.completed, .completed):
            return true
        case (.error(let lhsMessage), .error(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

/// Represents permission status
enum PermissionStatus: Equatable {
    case notDetermined // Haven't asked yet
    case granted // User said yes
    case denied  //User said no
}

///Model to hold our transcription data
struct TranscriptionResult: Equatable {
    let text: String
    let duration: TimeInterval
    let timestamp: Date
}
