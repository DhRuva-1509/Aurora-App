//
//  ForgotPasswordView.swift
//  Aurora
//
//  Created by Dhruva Patil on 2025-10-03.
//

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject var forgotPasswordViewModel = ForgotPasswordViewModel()
    @State private var isAnimation: Bool = false
    
    var body: some View {
        NavigationStack{
            ScrollView {
                Spacer()
                PulsingImageCircle(image: Image("ForgotPassword-Screen"), isAnimating: isAnimation, imageHeight: 250)
                    .onAppear{isAnimation = true}
            
                Spacer()
            
                VStack{
                    Text("Forgot Password")
                        .font(.system(.largeTitle, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 30)
                        .opacity(isAnimation ? 1 : 0)
                        .offset(y: isAnimation ? 0 : 20)
                        .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimation)
                
                        VStack(spacing: 20){
                            HStack(spacing: 12) {
                                Image(systemName: "envelope")
                                    .foregroundStyle(.blue)
                                    .font(.system(size: 18))
                            
                                TextField("", text: $forgotPasswordViewModel.email, prompt: Text("Email").foregroundColor(.gray.opacity(0.6)))
                                    .font(.system(size: 16))
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(Color(.systemGray6).opacity(0.5))
                            .cornerRadius(12)
                            .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(forgotPasswordViewModel.email.isEmpty ? Color.gray.opacity(0.2) : Color.blue, lineWidth: 1.5)
                            )
                        
                            Button{
                                forgotPasswordViewModel.sendOtp()
                            }label: {
                                Text("Send OTP")
                                    .font(.system(.title3, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                            .navigationDestination(isPresented: $forgotPasswordViewModel.isNavigateToVerifyOtp, destination: {OtpView()})
                        }.padding()
                        Spacer()
                    }
                }
           
            }
        }
    }


#Preview {
    ForgotPasswordView()
}
