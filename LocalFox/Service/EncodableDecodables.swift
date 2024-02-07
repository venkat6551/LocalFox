//
//  Decodables.swift
//  Hapag-Lloyd
//
//  Encodable/Decodables for request/response data and convert API JSON response from/into swift structs directly.
//
//  Created by Meet Vora on 2022-08-16.
//

import Foundation

struct ErrorResponseDecodable: Decodable {
    let success: Bool
    let error: String
}

struct SuccessResponseDecodable: Decodable {
    let success: Bool
    let data: String
}


struct FCMRegistrationResponseDecodable: Decodable {
    let success: Bool
    let data: FCMRegistrationResponseData
}


struct OptionalErrorResponseDecodable: Decodable {
    let success: Bool
    let error: String?
}

struct AddJobNotesDataResponseDecodable: Decodable {
    let success: Bool
    let data: NotesDataResponse
}

struct NotesDataResponse: Decodable {
    var job: String
    var partner: String
    var activityType: String
    var activityDescription: String
    var _id: String
    var notes: String
    var createdDate: String
    var lastUpdatedDate: String
}

struct FCMRegistrationResponseData: Decodable {
    let _id:String
}

struct ProfileDeleteSuccessDecodable: Decodable {
    let success: Bool
    let data: Emptystruct
}

struct Emptystruct: Decodable {
}
struct validateMobileCodeDecodable: Decodable {
    let success: Bool
    let mobileVerificationReference: String
    let data: String
}

struct validateEmailCodeDecodable: Decodable {
    let success: Bool
    let emailVerificationReference: String
    let data: String
}

struct RegisterResponseDecodable: Decodable {
    let success: Bool?
    let token: String?
    let expiry: String?
}

struct LoginResponseDecodable: Decodable {
    let success: Bool?
    let token: String?
    let expiry: String?
    let isMobileVerified: Bool?
}


struct AuthenticateResponseDecodable: Decodable {
    let id: Int?
    let parentUserId: Int?
    let createdByUserId: Int?
    let userStatus: String?
    let token: String?
}

struct GetUsersResponseDecodable: Decodable {
    
    let userId: Int?
    let parentUserId: Int?
    let createdByUserId: Int?
    let mailAddress: String?
    let status: String?
    
}

struct CreateInstallerResponseDecodable: Decodable {
    
    struct Permission: Decodable {
        let isAdministrator: Bool
        let allowedNewBuilds: Bool
    }
    
    let userId: Int?
    let parentUserId: Int?
    let createdByUserId: Int?
    let status: String?
    let pushToken: String?
    let permissions: Permission?
    
}

struct DeleteUserResponseDecodable: Decodable {
    
    struct Permission: Decodable {
        let isAdministrator: Bool
        let allowedNewBuilds: Bool
    }
    
    let userId: Int?
    let parentUserId: Int?
    let createdByUserId: Int?
    let status: String?
    let pushToken: String?
    let permissions: Permission?
    
}



struct CreatePairResponseDecodable: Decodable {
    
    let longitude: Double?
    let latitude: Double?
    let newBuild: Bool?
    let tries: Int?
    let status: String?
    let pairingId: Int?
    let pairingStatus: String?
    let deviceId: String?
    let containerId: String?
    let requestedBy: Int?
    
}
