//
//  PulsingImageCircle.swift
//  Aurora
//
//  Created by Dhruva Patil on 2025-10-03.
//

import Foundation
import SwiftUI

struct PulsingImageCircle: View {
    let image: Image
    let isAnimating: Bool
    
    var size: CGFloat = 280
    var ringColor: Color = .blue
    var ringOpacity: Double = 0.2
    var pulseRange: ClosedRange<CGFloat> = 0.9...1.1
    var pulseDuration: Double = 1.5
    var imageHeight: CGFloat = 200
    var springDamping: CGFloat = 0.6
    var springDelay: Double = 0.2
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(ringColor.opacity(ringOpacity))
                .frame(width: size, height: size)
                .scaleEffect(isAnimating ? pulseRange.upperBound : pulseRange.lowerBound)
                .animation(.easeInOut(duration: pulseDuration).repeatForever(autoreverses: true), value: isAnimating)
            
            image
                .resizable()
                .scaledToFit()
                .frame(height: imageHeight)
                .offset(y: isAnimating ? 0 : 10)
                .animation(.spring(dampingFraction: springDamping).delay(springDelay), value: isAnimating)
        }
    }
}
