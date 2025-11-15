//
//  SignUpViewModel.swift
//  Aurora
//
//  Created by Dhruva Patil on 2025-10-03.
//

import Foundation
import Combine
import Amplify

public final class SignUpViewModel: ObservableObject {
    //MARK: - Inputs
    @Published var email: String = ""
    @Published var fullName: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var isConfirmPasswordVisible: Bool = false
    @Published var navigateToOtpScreen: Bool = false
    
    //MARK: - Outputs
    @Published var errorMessages: String = ""
    @Published var showErrorMessage: String = ""
    
    func togglePasswordVisibilty(){
        isPasswordVisible.toggle()
    }
    
    func toggleConfirmPasswordVisibilty() {
        isConfirmPasswordVisible.toggle()
    }
    
    func validPasswordFormat(password: String) -> Bool {
        let passwordRegex = #"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$"#
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    func validEmailFormat(email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func validateCredentials(fullName: String, email: String, password: String, confirmPassword: String) async{
        if(fullName == "")
        {
            print("Full name is required")
            return
        }
        else if(!validEmailFormat(email: email))
        {
            print("not valid password")
            return
        }
        else if (password != confirmPassword){
            print("Password mismatch")
            return
        }
        else if(!validPasswordFormat(password: password))
        {
            print("Weak Password")
        }
        else {
            await signUp(fullName: fullName, email: email, password: password)
        }
    
    }
    
    func signUp(fullName: String, email: String, password: String) async {
        let userAttributes = [AuthUserAttribute(.email, value: email), AuthUserAttribute(.name, value: fullName)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        
        do {
            let signUpRequest = try await Amplify.Auth.signUp(username: email,
                                                              password: password,
                                                              options: options )
            
            if case let .confirmUser(deliveryDetails, _, userId) = signUpRequest.nextStep {
                        print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId)))")
                        navigateToOtpScreen.toggle()
                    } else {
                        print("SignUp Complete")
                    }
                } catch let error as AuthError {
                    print("An error occurred while registering a user \(error)")
                } catch {
                    print("Unexpected error: \(error)")
                }
        }
    }

