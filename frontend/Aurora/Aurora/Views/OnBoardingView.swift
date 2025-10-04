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
        NavigationStack{
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
            .navigationDestination(isPresented: $vm.navigateToSignIn) { SignInView() }
        }
    }

}

private struct OnboardingPageView: View {
    let item: OnboardingItem
    let isAnimating: Bool

    var body: some View {
        VStack(spacing: 30) {
            PulsingImageCircle(image: Image(item.imageName), isAnimating: isAnimating, imageHeight: item.height)

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

// MARK: - Preview
#Preview {
    OnBoardingView()
}

