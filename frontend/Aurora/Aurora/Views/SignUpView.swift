//
//  SignUpView.swift
//  Aurora
//
//  Created by Dhruva Patil on 2025-10-03.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var signUpViewModel = SignUpViewModel()
    @State private var isAnimation = false
    
    var body: some View {
        NavigationStack{
            ScrollView {
    
                PulsingImageCircle(image: Image("SignUp-Screen"), isAnimating: isAnimation, imageHeight: 250)
                    .onAppear{isAnimation = true}
            
                Spacer()
            
                VStack{
                    Text("Sign Up")
                        .font(.system(.largeTitle, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 30)
                        .opacity(isAnimation ? 1 : 0)
                        .offset(y: isAnimation ? 0 : 20)
                        .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimation)
                
                        VStack(spacing: 20){
                            //MARK: - Full name
                            HStack(spacing: 12) {
                                Image(systemName: "person.circle")
                                    .foregroundStyle(.blue)
                                    .font(.system(size: 18))
                            
                                TextField("", text: $signUpViewModel.fullName, prompt: Text("Full Name").foregroundColor(.gray.opacity(0.6)))
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
                                .stroke(signUpViewModel.email.isEmpty ? Color.gray.opacity(0.2) : Color.blue, lineWidth: 1.5)
                            )
                            //MARK: - Email
                            HStack(spacing: 12) {
                                Image(systemName: "envelope")
                                    .foregroundStyle(.blue)
                                    .font(.system(size: 18))
                            
                                TextField("", text: $signUpViewModel.email, prompt: Text("Email").foregroundColor(.gray.opacity(0.6)))
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
                                .stroke(signUpViewModel.email.isEmpty ? Color.gray.opacity(0.2) : Color.blue, lineWidth: 1.5)
                            )
                        
                            //MARK: - Password
                            HStack(spacing: 12) {
                                Button{
                                    signUpViewModel.togglePasswordVisibilty()
                                }label: {
                                    Image(systemName: signUpViewModel.isPasswordVisible ? "eye.slash" : "eye")
                                        .foregroundStyle(.blue)
                                }
                            
                                if !signUpViewModel.isPasswordVisible {
                                    SecureField("", text: $signUpViewModel.password, prompt: Text("Password").foregroundStyle(.gray.opacity(0.6)))
                                        .font(.system(size: 16))
                                        .autocorrectionDisabled()
                                        .autocapitalization(.none)
                                } else {
                                    TextField("", text: $signUpViewModel.password, prompt: Text("Password").foregroundStyle(.gray.opacity(0.6)))
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
                                    .stroke(signUpViewModel.password.isEmpty ? Color.gray.opacity(0.2) : Color.blue, lineWidth: 1.5)
                            )
                    
                            //MARK: Confirm Password
                            HStack(spacing: 12) {
                                Button{
                                    signUpViewModel.toggleConfirmPasswordVisibilty()
                                }label: {
                                    Image(systemName: signUpViewModel.isConfirmPasswordVisible ? "eye.slash" : "eye")
                                        .foregroundStyle(.blue)
                                }
                            
                                if !signUpViewModel.isConfirmPasswordVisible {
                                    SecureField("", text: $signUpViewModel.confirmPassword, prompt: Text("Confirm Password").foregroundStyle(.gray.opacity(0.6)))
                                        .font(.system(size: 16))
                                        .autocorrectionDisabled()
                                        .autocapitalization(.none)
                                } else {
                                    TextField("", text: $signUpViewModel.confirmPassword, prompt: Text("Confirm Password").foregroundStyle(.gray.opacity(0.6)))
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
                                    .stroke(signUpViewModel.confirmPassword.isEmpty ? Color.gray.opacity(0.2) : Color.blue, lineWidth: 1.5)
                            )
                            
                            Button{
                                
                            }label: {
                                Text("Sign Up")
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
                                Text("Already have an account?")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.gray)
                                
                                NavigationLink(destination: SignInView()){
                                    Text("Sign In")
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
    SignUpView()
}
