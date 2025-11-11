//
//  HomePage.swift
//  Aurora
//
//  Created by Dhruva Patil on 2025-10-07.
//

import SwiftUI
import AVFoundation

struct HomePage: View {
    @State var isAnimation: Bool = false
    var body: some View {
       
        VStack{
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
            
            
            Button{
              
            }label: {
                ZStack{
                    Circle()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(Color.blue)
                    
                    Image(systemName: "mic.fill")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(.white)
                    }
            }
            
            
              Spacer()
            }
    }
}

#Preview {
    HomePage()
}
