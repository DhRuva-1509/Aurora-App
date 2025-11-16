//
//  HomePage.swift
//  Aurora
//

import SwiftUI
import AVFoundation
import Speech

struct HomePage: View {
    @State var isAnimation: Bool = false
    @StateObject private var vm = SpeechViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            ParticleAnimation()
                .frame(width: 280, height: 280)
                .scaleEffect(isAnimation ? 1.02 : 1.3)
                .animation(
                    .easeInOut(duration: 1.7)
                        .repeatForever(autoreverses: true),
                    value: isAnimation
                )
                .onAppear { isAnimation = true }
                .onDisappear { isAnimation = false }
            
            Spacer()
            
            VStack(spacing: 20) {
                
                Text(vm.isRecording ? "Recording…" : "Press to Record")
                    .font(.title)
                
                Button(vm.isRecording ? "Stop" : "Start") {
                    if vm.isRecording {
                        vm.stopRecording()
                    } else {
                        vm.startRecording()
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(12)
                
                
                // FINAL OUTPUT
                if !vm.finalizedTranscript.isEmpty {
                    Text(vm.finalizedTranscript)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // LIVE OUTPUT
                if !vm.volatileTranscript.isEmpty {
                    Text(vm.volatileTranscript)
                        .font(.title3)
                        .foregroundColor(.gray)
                        .italic()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // BACKEND RESPONSE (AFTER STOP)
                if !vm.backendResponse.isEmpty {
                    Text(vm.backendResponse)
                        .font(.title3)
                        .foregroundColor(.green)
                        .padding(.top, 25)
                        .padding(.horizontal)
                }
            }
            .padding()
            
            Spacer()
        }
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    HomePage()
}
