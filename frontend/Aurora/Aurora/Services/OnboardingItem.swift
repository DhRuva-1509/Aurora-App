//
//  OnboardingItem.swift
//  Aurora
//
//  Created by Dhruva Patil on 2025-10-02.
//

import Foundation

struct OnboardingItem: Identifiable, Equatable {
    let id: Int
    let title: String
    let description: String
    let imageName: String
}

extension OnboardingItem {
    static let sampleData: [OnboardingItem] = [
        .init(id: 0, title: "Improved Emotional Awareness", description: "Therapy helps you understand your emotions better, making it easier to manage stress and anxiety.", imageName: "OnboardingScreen-1"),
        .init(id: 1, title: "Healthy Coping Skills", description: "A therapist can teach practical strategies to handle challenges without feeling overwhelmed.", imageName: "OnboardingScreen-2"),
        .init(id: 2, title: "Stronger Relationships", description: "By improving communication and self-awareness, therapy often leads to more meaningful connections with others.", imageName: "OnboardingScreen-3"),
        .init(id: 3, title: "Long-Term Resilience", description: "Therapy builds lasting skills that help you bounce back from setbacks and maintain mental well-being.", imageName: "OnboardingScreen-4")
    ]
}
