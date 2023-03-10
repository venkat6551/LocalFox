//
//  LoginCredentialsModel.swift
//  Hapag-Lloyd
//
//  Created by Meet Vora on 2022-07-18.
//

import Foundation

struct LoginCredentialsModel: Codable {
    
    var email: String = ""
    var password: String = ""
    
    var isValid: Bool {
        !email.isEmpty && !password.trimmingCharacters(in: .whitespaces).isEmpty && email.trimmingCharacters(in: .whitespaces).isValidEmail
    }
    
}
