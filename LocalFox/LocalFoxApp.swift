//
//  LocalFoxApp.swift
//  LocalFox
//
//  Created by Venkatesh karra on 12/8/22.
//

import SwiftUI

@main
struct LocalFoxApp: App {
    @StateObject var authenticationStatus = AuthenticationStatus()
    var body: some Scene {
        WindowGroup {
//            if authenticationStatus.isAuthenticated {
//                LandingView()
//            } else {
                LoginView()
                    .environmentObject(authenticationStatus) // Pass this state-object so that we can update it in nested view
//            }
        }
    }
}
