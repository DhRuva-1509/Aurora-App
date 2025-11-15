//
//  AuroraApp.swift
//  Aurora
//
//  Created by Dhruva Patil on 2025-09-28.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

@main
struct AuroraApp: App {
    
    func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Amplify Configured Successfully")
        }catch{
            print("Failed to configure Amplify: \(error)")
        }
    }
    
    init(){
        configureAmplify()
    }
    var body: some Scene {
        WindowGroup {
            OnBoardingView()
        }
    }
}
