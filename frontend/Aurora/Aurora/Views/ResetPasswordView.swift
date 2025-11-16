//
//  ResetPasswordView.swift
//  Aurora
//
//  Created by Dhruva Patil on 2025-11-14.
//

import SwiftUI

struct ResetPasswordView: View {
    @State private var isAnimation: Bool = false
    @StateObject var forgotPasswordViewModel = ForgotPasswordViewModel()
    let email: String
    let otp: String
    var body: some View {
        NavigationStack{
            ScrollView {
                Spacer()
                PulsingImageCircle(image: Image("ForgotPassword-Screen"), isAnimating: isAnimation, imageHeight: 250)
                    .onAppear{isAnimation = true}
                
                Spacer()
                
                VStack{
                    Text("Reset Password")
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
                            Button{
                                forgotPasswordViewModel.togglePasswordVisibilty()
                            }label: {
                                Image(systemName: forgotPasswordViewModel.isPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundStyle(.blue)
                            }
                        
                            if !forgotPasswordViewModel.isPasswordVisible {
                                SecureField("", text: $forgotPasswordViewModel.password, prompt: Text("Password").foregroundStyle(.gray.opacity(0.6)))
                                    .font(.system(size: 16))
                                    .autocorrectionDisabled()
                                    .autocapitalization(.none)
                            } else {
                                TextField("", text: $forgotPasswordViewModel.password, prompt: Text("Password").foregroundStyle(.gray.opacity(0.6)))
                                    .font(.system(size: 16))
                                    .autocorrectionDisabled()
                                    .autocapitalization(.none)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color(.systemGray6).opacity(0.5))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(forgotPasswordViewModel.password.isEmpty ? Color.gray.opacity(0.2) : Color.blue, lineWidth: 1.5)
                        )
                        
                        
                        HStack(spacing: 12) {
                            Button{
                                forgotPasswordViewModel.toggleConfirmPasswordVisibilty()
                            }label: {
                                Image(systemName: forgotPasswordViewModel.isConfirmPasswordVisible ? "eye.slash" : "eye")
                                    .foregroundStyle(.blue)
                            }
                        
                            if !forgotPasswordViewModel.isConfirmPasswordVisible {
                                SecureField("", text: $forgotPasswordViewModel.confirmPassword, prompt: Text("Confirm Password").foregroundStyle(.gray.opacity(0.6)))
                                    .font(.system(size: 16))
                                    .autocorrectionDisabled()
                                    .autocapitalization(.none)
                            } else {
                                TextField("", text: $forgotPasswordViewModel.confirmPassword, prompt: Text("Confirm Password").foregroundStyle(.gray.opacity(0.6)))
                                    .font(.system(size: 16))
                                    .autocorrectionDisabled()
                                    .autocapitalization(.none)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color(.systemGray6).opacity(0.5))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(forgotPasswordViewModel.confirmPassword.isEmpty ? Color.gray.opacity(0.2) : Color.blue, lineWidth: 1.5)
                        )
                        
                        Button{
                            Task{
                                await forgotPasswordViewModel.validatePassword(username: email, otp: otp, password: forgotPasswordViewModel.password, confirmPassword: forgotPasswordViewModel.confirmPassword)
                            }
                            
                        }label: {
                            Text("Verify Otp")
                                .font(.system(.title3, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                        }.navigationDestination(isPresented: $forgotPasswordViewModel.isNavigateToSignIn, destination: {SignInView()})
                    }
                }.padding()
            }
        }
    }
}

#Preview {
    ResetPasswordView(email: "", otp: "")
}
