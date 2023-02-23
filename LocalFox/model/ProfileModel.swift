//
//  ProfileModel.swift
//  LocalFox
//
//  Created by venkatesh karra on 16/02/23.
//



import Foundation

struct ProfileModel: Decodable {
    var success: Bool?
    var data: ProfileData?
}

struct ProfileData: Codable {
    var NotificationSettings:NotificationSettings
    let checkList: CheckList
    var location:Location?
    let _id: String
    let firstName: String
    let lastName: String
    let emailAddress: String
    let isMobileVerified: Bool
    let isEmailVerified: Bool
    let mobileNumber: String
    let profilePhoto: String
    let isActive: Bool
    let isApproved: Bool
    let role: String
    let serviceArea: Int
    let createdDate: String
    let lastUpdatedDate: String
}

struct Location: Codable {
    let type: String
    let formattedAddress: String
    //let unit: Int
    let streetName: String
    let suburb: String
    let state: String
    let postCode: String
    let country: String
    let googlePlaceId: String
}

struct NotificationSettings: Codable {
    var pushNotifications: Bool
    var smsNotifications: Bool
    var emailNotifications: Bool
    var announcements: Bool
    var events: Bool
}

struct CheckList: Codable {
    let isBusinessDetailsCaptured: Bool
    let isContractSigned: Bool
    let isLicenceVerified: Bool
    let isIdCheckComplete: Bool
    let isPoliceCheckComplete: Bool
    let isInsuranceVerified: Bool
}

