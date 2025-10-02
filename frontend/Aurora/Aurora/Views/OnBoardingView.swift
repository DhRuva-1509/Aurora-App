//
//  OnBoardingView.swift
//  Aurora
//
//  Created by Dhruva Patil on 2025-10-01.
//

import SwiftUI

struct OnBoardingView: View {
    @StateObject private var vm: OnboardingViewModel

    init(viewModel: OnboardingViewModel = OnboardingViewModel()) {
        _vm = StateObject(wrappedValue: viewModel)
    }

var body: some View {
    VStack {
        TabView(selection: $vm.currentPage) {
            ForEach(vm.pages.indices, id: \.self) { index in
                let item = vm.pages[index]
                OnboardingPageView(item: item, isAnimating: vm.isAnimating)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .animation(.spring(), value: vm.currentPage)
        
        // Dots
        HStack(spacing: 12) {
            ForEach(0..<vm.pageCount, id: \.self) { index in
                Circle()
                    .fill(vm.currentPage == index ? Color.blue : Color.gray.opacity(0.5))
                    .frame(width: vm.currentPage == index ? 12 : 8,
                           height: vm.currentPage == index ? 12 : 8)
                    .animation(.spring(), value: vm.currentPage)
            }
        }
        .padding(.bottom, 20)
        
        // CTA Button
        Button(action: vm.next) {
            Text(vm.buttonTitle)
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.white) // more compatible than foregroundStyle
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
            }
            .onAppear { vm.onAppear() }
            }
        }

private struct OnboardingPageView: View {
    let item: OnboardingItem
    let isAnimating: Bool

    var body: some View {
        VStack(spacing: 30) {
            PulsingImageCircle(imageName: item.imageName, isAnimating: isAnimating)

            VStack(spacing: 20) {
                Text(item.title)
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimating)

                Text(item.description)
                    .font(.system(.title3, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimating)
            }
        }
        .padding(.top, 50)
    }
}

private struct PulsingImageCircle: View {
    let imageName: String
    let isAnimating: Bool

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.blue.opacity(0.2))
                .frame(width: 280, height: 280)
                .scaleEffect(isAnimating ? 1.1 : 0.9)
                .animation(.easeInOut(duration: 1.5).repeatForever(), value: isAnimating)

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: imageHeight(for: imageName))
                .offset(y: isAnimating ? 0 : 20)
                .animation(.spring(dampingFraction: 0.6).delay(0.2), value: isAnimating)
        }
}

    private func imageHeight(for name: String) -> CGFloat {
        switch name {
            case "OnboardingScreen-1": return 280
            case "OnboardingScreen-2": return 250
            case "OnboardingScreen-3": return 250
            case "OnboardingScreen-4": return 200
            default: return 250
        }
    }
}

// MARK: - Preview
#Preview {
    OnBoardingView()
}


