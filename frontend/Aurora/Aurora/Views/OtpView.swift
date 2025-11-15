//
//  OtpView.swift
//  Aurora
//
//  Created by Dhruva Patil on 2025-10-03.
//

import SwiftUI

struct OtpView: View {
    @StateObject var forgotPasswordViewModel = ForgotPasswordViewModel()
    @State var isAnimation: Bool = false
    @FocusState private var isOTPFieldFocused: Bool
    let email: String
    let flow: String
    
    var body: some View {
        NavigationStack{
            ScrollView {
                Spacer()
                PulsingImageCircle(image: Image("ForgotPassword-Screen"), isAnimating: isAnimation, imageHeight: 250)
                    .onAppear { isAnimation = true; isOTPFieldFocused = true }
            
                Spacer()
            
                VStack{
                    Text("Verify OTP")
                        .font(.system(.largeTitle, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 30)
                        .opacity(isAnimation ? 1 : 0)
                        .offset(y: isAnimation ? 0 : 20)
                        .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimation)
                
                        VStack(spacing: 20){
                            
                            HStack(spacing: 0){
                                ForEach(0...5, id: \.self){index in
                                    OTPTextBox(index)
                                }
                            }
                            .background {
                                TextField("", text: $forgotPasswordViewModel.otp.limit(6))
                                    .keyboardType(.numberPad)
                                    .textContentType(.oneTimeCode)
                                    .focused($isOTPFieldFocused)
                                    .onChange(of: forgotPasswordViewModel.otp) { newValue in
                                        let filtered = newValue.filter { $0.isNumber }
                                        if filtered != newValue {
                                            forgotPasswordViewModel.otp = String(filtered.prefix(6))
                                        }
                                    }
                                    .frame(width: 0, height: 0)
                                    .opacity(0.01)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture { isOTPFieldFocused = true }
                            .padding(.bottom, 20)
                            .padding(.top, 10)
                            
                        
                            Button{
                                Task{
                                    await forgotPasswordViewModel.verifyOtp(otp: forgotPasswordViewModel.otp, flow: flow, username: email)
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
                            }.disableWithOpacity(forgotPasswordViewModel.otp.count < 6)
                                .navigationDestination(isPresented: $forgotPasswordViewModel.isNavigateToSignIn, destination: {SignInView()})
                                .navigationDestination(isPresented: $forgotPasswordViewModel.isNavigateToResetPassword, destination: {ResetPasswordView(email: email, otp: forgotPasswordViewModel.otp)})
                            
                        }.padding()
                    
                        Spacer()
                    }
                }
           
            }
        }
    @ViewBuilder
    func OTPTextBox(_ index: Int) -> some View {
        ZStack {
            if forgotPasswordViewModel.otp.count > index {
                let startIndex = forgotPasswordViewModel.otp.startIndex
                let charIndex = forgotPasswordViewModel.otp.index(startIndex, offsetBy: index)
                let charToString = String(forgotPasswordViewModel.otp[charIndex])
                Text(charToString)
            }else{
                Text("")
            }
        }.frame(width: 45, height: 45)
            .background{
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(.gray, lineWidth: 0.5)
            }
            .frame(maxWidth: .infinity)
        }
    }


#Preview {
    OtpView( email: "", flow: "")
}

extension Binding where Value == String {
    func limit(_ length: Int) -> Binding<String> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = String(newValue.prefix(length))
            }
        )
    }
}

extension View{
    func disableWithOpacity(_ condition: Bool) -> some View{
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
}

