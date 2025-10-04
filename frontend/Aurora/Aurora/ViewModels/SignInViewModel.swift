//
//  SignInViewModel.swift
//  Aurora
//
//  Created by Dhruva Patil on 2025-10-03.
//

import Foundation
import Combine

public final class SignInViewModel: ObservableObject {
    //MARK: - Inputs
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false
    
    //MARK: - Outputs
    @Published var errorMessage: String = ""
    @Published var showErrorMessage: String = ""
    
    func togglePasswordVisibilty() {
        isPasswordVisible.toggle()
    }
    
    
    func signIn() {
        
    }
}
