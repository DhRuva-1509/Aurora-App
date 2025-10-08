//
//  ForgotPasswordViewModel.swift
//  Aurora
//
//  Created by Dhruva Patil on 2025-10-03.
//

import Foundation
import Combine

public final class ForgotPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var otp: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isNavigateToVerifyOtp: Bool = false
    
    func sendOtp(){
        isNavigateToVerifyOtp = true
    }
    
    func verifyOtp(){
        
    }
    
}
