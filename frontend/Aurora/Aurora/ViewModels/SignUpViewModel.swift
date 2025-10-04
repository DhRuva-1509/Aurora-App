//
//  SignUpViewModel.swift
//  Aurora
//
//  Created by Dhruva Patil on 2025-10-03.
//

import Foundation
import Combine

public final class SignUpViewModel: ObservableObject {
    //MARK: - Inputs
    @Published var email: String = ""
    @Published var fullName: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isPasswordVisible: Bool = false
    @Published var isConfirmPasswordVisible: Bool = false
    
    //MARK: - Outputs
    @Published var errorMessages: String = ""
    @Published var showErrorMessage: String = ""
    
    func togglePasswordVisibilty(){
        isPasswordVisible.toggle()
    }
    
    func toggleConfirmPasswordVisibilty() {
        isConfirmPasswordVisible.toggle()
    }
    func signUp(){
        
    }
}
