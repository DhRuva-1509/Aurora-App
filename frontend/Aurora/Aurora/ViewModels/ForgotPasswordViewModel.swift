//
//  ForgotPasswordViewModel.swift
//  Aurora
//
//  Created by Dhruva Patil on 2025-10-03.
//

import Foundation
import Combine
import Amplify

public final class ForgotPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var otp: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isNavigateToVerifyOtp: Bool = false
    @Published var isNavigateToSignIn: Bool = false
    @Published var isPasswordVisible: Bool = false
    @Published var isConfirmPasswordVisible: Bool = false
    @Published var isNavigateToResetPassword: Bool = false
    
    func togglePasswordVisibilty(){
        isPasswordVisible.toggle()
    }
    
    func toggleConfirmPasswordVisibilty() {
        isConfirmPasswordVisible.toggle()
    }
    
    func sendOtp(username: String) async {
        do {
            let resetResult = try await Amplify.Auth.resetPassword(for: username)
            
            switch resetResult.nextStep {
                        case .confirmResetPasswordWithCode(let deliveryDetails, let info):
                            print("Confirm reset password with code send to - \(deliveryDetails) \(String(describing: info))")
                            isNavigateToVerifyOtp = true
                
                        case .done:
                            print ("Reset Complete")
            }
            
        } catch let error as AuthError {
            print("Reset password failed with error \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
        
    }
    
    func verifyOtp(otp: String, flow: String, username:String) async{
        if(flow == "signUpFlow")
        {
            await confirmSignUp(for: username, with: otp)
        }
        
        else if(flow == "forgotPasswordFlow")
        {
            isNavigateToResetPassword.toggle()
            print(flow)
        }
    }
    
    func confirmSignUp(for username: String, with otpCode: String) async {
        do {
            let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
                for: username,
                confirmationCode: otpCode
            )
            print("Confirm sign up result completed: \(confirmSignUpResult.isSignUpComplete)")
            isNavigateToSignIn.toggle()
        }catch let error as AuthError{
            print("An error occurred while confirming sign up \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func confirmResetPassword(username: String, newPassword: String, otp: String) async {
        do {
            print(username, newPassword, otp)
            try await Amplify.Auth.confirmResetPassword(
                for: username,
                with: newPassword,
                confirmationCode: otp)
            
            print("Reset Password Successful")
        } catch let error as AuthError {
            print("Reset password failed with error \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
}
