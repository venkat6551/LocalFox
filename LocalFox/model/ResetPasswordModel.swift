//
//  ResetPasswordModel.swift
//  LocalFox
//
//  Created by venkatesh karra on 06/02/23.
//

import Foundation

struct ResetPasswordModel: Codable {
    
    var email: String = ""
    var verificationCode: String = ""
    
    var isValidEmail: Bool {
        !email.isEmpty  && email.trimmingCharacters(in: .whitespaces).isValidEmail
    }
}

