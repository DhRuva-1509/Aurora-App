//
//  SignInView.swift
//  Aurora
//
//  Created by Dhruva Patil on 2025-10-03.
//

import SwiftUI

struct SignInView: View {
    @StateObject private var signInViewModel = SignInViewModel()
    @State private var isAnimation = false
    
    var body: some View {
        NavigationStack{
            ScrollView {
                Spacer()
                PulsingImageCircle(image: Image("SignIn-Screen"), isAnimating: isAnimation, imageHeight: 250)
                    .onAppear{isAnimation = true}
            
                Spacer()
            
                VStack{
                    Text("Sign In")
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
                            
                                TextField("", text: $signInViewModel.email, prompt: Text("Email").foregroundColor(.gray.opacity(0.6)))
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
                                .stroke(signInViewModel.email.isEmpty ? Color.gray.opacity(0.2) : Color.blue, lineWidth: 1.5)
                            )
                        
                            HStack(spacing: 12) {
                                Button{
                                    signInViewModel.togglePasswordVisibilty()
                                }label: {
                                    Image(systemName: signInViewModel.isPasswordVisible ? "eye.slash" : "eye")
                                        .foregroundStyle(.blue)
                                }
                            
                                if !signInViewModel.isPasswordVisible {
                                    SecureField("", text: $signInViewModel.password, prompt: Text("Password").foregroundStyle(.gray.opacity(0.6)))
                                        .font(.system(size: 16))
                                        .autocorrectionDisabled()
                                        .autocapitalization(.none)
                                } else {
                                    TextField("", text: $signInViewModel.password, prompt: Text("Password").foregroundStyle(.gray.opacity(0.6)))
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
                                    .stroke(signInViewModel.password.isEmpty ? Color.gray.opacity(0.2) : Color.blue, lineWidth: 1.5)
                            )
                            NavigationLink(destination: ForgotPasswordView()){
                                Text("Forgot Password?")
                                    .font(.system(size: 14))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundStyle(.gray)
                            }
                            Button{
                                
                            }label: {
                                Text("Sign In")
                                    .font(.system(.title3, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                            
                            
                            HStack {
                                Text("Don't have an account?")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.gray)
                                
                                NavigationLink(destination: SignUpView()){
                                    Text("Sign Up")
                                        .font(.system(size: 15))
                                }
                            }
                        }.padding()
                        Spacer()
                    }
                }
           
            }
        }
    }

#Preview {
    @Previewable @StateObject var vm = SignInViewModel()
    SignInView()
}

