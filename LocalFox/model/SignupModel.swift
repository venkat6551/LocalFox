//
//  SignupModel.swift
//  LocalFox
//
//  Created by venkatesh karra on 11/02/23.
//

import Foundation
struct SignupModel: Codable {
    var firstName: String = ""
    var lastName: String = ""
    var mobileNumber: String = ""
    var email: String = ""
    var verificationCode: String = ""
    var mobileVerificationReference: String?
    var emailVerificationReference: String?
    
    var isValidFirstName: Bool {
        !firstName.isEmpty  && !firstName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    var isValidLastName: Bool {
        !lastName.isEmpty  && !lastName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    var isValidEmail: Bool {
        !email.isEmpty  && email.trimmingCharacters(in: .whitespaces).isValidEmail
    }
    var isValidMobileNumber: Bool {
        let mobileNumberLength = mobileNumber.hasPrefix("04") ? 10 : 9
         return (mobileNumber.hasPrefix("04") || mobileNumber.hasPrefix("4"))
        && mobileNumber.count == mobileNumberLength
    }
    
    var formattedMobileNumber: String {
        mobileNumber.hasPrefix("0") ? mobileNumber : "0\(mobileNumber)"
    }
}

