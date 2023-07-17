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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            if authenticationStatus.isAuthenticated {
                NavigationStack {
                    LandingView(profileVM: ProfileViewModel()).environmentObject(authenticationStatus)
                }
            } else {
                LoginView()
                    .environmentObject(authenticationStatus)// Pass this state-object so that we can update it in nested view
            }
        }
    }
}
