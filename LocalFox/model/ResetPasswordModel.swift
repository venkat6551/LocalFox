//
//  ResetPasswordModel.swift
//  LocalFox
//
//  Created by venkatesh karra on 06/02/23.
//

import Foundation

struct ResetPasswordModel: Codable {
    
    var email: String = ""
    var password: String = ""
    
    var isValid: Bool {
        !email.isEmpty && !password.trimmingCharacters(in: .whitespaces).isEmpty && email.trimmingCharacters(in: .whitespaces).isValidEmail
    }
    
}

