//
//  AuthenticationStatus.swift
//  Hapag-Lloyd
//
//  Created by Meet Vora on 2022-07-18.
//

import Foundation
import SwiftUI

class AuthenticationStatus: ObservableObject {
    
    @Published private(set) var isAuthenticated = MyUserDefaults.isLoggedIn
    
    enum AuthenticationError: Error, Identifiable {
        case invalidEmail
        case invalidPassword
        case invalidCredentials
        case authenticationFail
        
        var id: String {
            self.localizedDescription
        }
        
        var description: String {
            switch self {
            case .invalidEmail: return Strings.ERROR_INVALID_EMAIL
            case .invalidPassword: return Strings.ERROR_INVALID_PASSWORD
            case .invalidCredentials: return Strings.ERROR_INVALID_LOGIN
            case .authenticationFail: return Strings.ERROR_AUTH_FAILED
            }
        }
        
        var title: String? {
            switch self {
            case .invalidEmail: return Strings.ERROR_INVALID_EMAIL_TITLE
            case .invalidPassword: return Strings.ERROR_INVALID_PASSWORD_TITLE
            case .invalidCredentials: return Strings.ERROR_INVALID_LOGIN_TITLE
            case .authenticationFail: return Strings.ERROR_AUTH_FAILED_TITLE
            }
        }
    }
    
    func setAuthenticated(authenticated: Bool) {
        withAnimation {
            isAuthenticated = authenticated
            MyUserDefaults.isLoggedIn = authenticated
            MyUserDefaults.isLinkUserSuccess = false
        }
    }
    
}
