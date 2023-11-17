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

struct ProfileData: Decodable {
    var NotificationSettings:NotificationSettings
    let checkList: CheckList
    var location:Location?
    let _id: String
    let firstName: String
    let lastName: String
    let emailAddress: String
    let isMobileVerified: Bool
    let isEmailVerified: Bool
    var mobileNumber: String
    var profilePhoto: String
    let isActive: Bool
    let isApproved: Bool
    let role: String
    let serviceArea: Int
    let createdDate: String
    let lastUpdatedDate: String
    
    func getFormattedLocation() -> String {
        return self.location?.getFormattedLocation() ?? ""
    }
}

struct Location: Decodable {
    let type: String?
    var formattedAddress: String?
    var streetNumber:String?
    var streetName: String?
    var suburb: String?
    var state: String?
    var postCode: String?
    var country: String?
    var googlePlaceId: String?
    
    
    func getShortFormattedLocation() -> String {
        
        var location = ""
        
        if let suburb = self.suburb {
            location = "\(location)\(suburb), "
        }
        if let state = self.state {
            location = "\(location)\(state) "
        }
        
        if let postCode = self.postCode {
            location = "\(location)\(postCode)"
        }
        
        return location
    }
    
    func getFormattedLocation() -> String {
        
        var location = ""
        
        if let streenNum = self.streetNumber {
            location = streenNum
        }
        if let streenName = self.streetName {
            location = "\(location) \(streenName)"
        }
        
        if location.count > 0 {
            location = "\(location) \n"
        }
        
        if let suburb = self.suburb {
            location = "\(location)\(suburb)"
        }
        if let state = self.state {
            location = "\(location) \(state)"
        }
        
        if let postCode = self.postCode {
            location = "\(location) \(postCode)"
        }
        return location
    }
}

struct NotificationSettings: Decodable {
    var pushNotifications: Bool
    var smsNotifications: Bool
    var emailNotifications: Bool
    var announcements: Bool
    var events: Bool
}

struct CheckList: Decodable {
    let isBusinessDetailsCaptured: Bool
    let isContractSigned: Bool
    let isLicenceVerified: Bool
    let isIdCheckComplete: Bool
    let isPoliceCheckComplete: Bool
    let isInsuranceVerified: Bool
}

