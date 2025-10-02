//
//  OnboardingViewModel.swift
//  Aurora
//
//  Created by Dhruva Patil on 2025-10-02.
//

import Foundation
import Combine

final class OnboardingViewModel: ObservableObject {
    // Inputs / State
    @Published var currentPage: Int = 0
    @Published var isAnimating: Bool = false

    // Data
    @Published private(set) var pages: [OnboardingItem]

    // Outputs
    var isLastPage: Bool { currentPage >= pages.count - 1 }
    var pageCount: Int { pages.count }
    var buttonTitle: String { isLastPage ? "Get Started" : "Next" }

    // Completion handler (inject from caller if you want to act on finish)
    var onComplete: (() -> Void)?

    init(pages: [OnboardingItem] = OnboardingItem.sampleData, onComplete: (() -> Void)? = nil) {
        self.pages = pages
        self.onComplete = onComplete
    }

    // MARK: - Lifecycle
    func onAppear() {
        // Trigger animation state after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.isAnimating = true
        }
    }

    // MARK: - Actions
    func next() {
        guard !isLastPage else { onComplete?(); return }
        currentPage += 1
        // retrigger per-page animations
        isAnimating = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.isAnimating = true
        }
    }
}
