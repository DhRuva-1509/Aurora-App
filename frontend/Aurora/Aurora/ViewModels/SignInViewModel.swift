//
//  SignInViewModel.swift
//  Aurora
//
//  Created by Dhruva Patil on 2025-10-03.
//

import Foundation
import Combine
import Amplify

public final class SignInViewModel: ObservableObject {
    //MARK: - Inputs
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var isSignInComplete: Bool = false
    
    //MARK: - Outputs
    @Published var errorMessage: String = ""
    @Published var showErrorMessage: String = ""
    
    func togglePasswordVisibilty() {
        isPasswordVisible.toggle()
    }
    
    
    func signIn(username: String, password: String) async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            if session.isSignedIn{
                print("A user is already signed in, signing them out first")
                try await Amplify.Auth.signOut()
            }
            let signInResult = try await Amplify.Auth.signIn(
                username: username,
                password: password)
            
            if signInResult.isSignedIn {
                print("Sign In")
                isSignInComplete = true
            }
        } catch let error as AuthError {
            print("Sign In failed \(error)")
        }catch {
            print("Unexpected error: \(error)")
        }
    }
}
