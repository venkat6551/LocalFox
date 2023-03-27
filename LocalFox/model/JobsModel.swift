//
//  JobModel.swift
//  LocalFox
//
//  Created by venkatesh karra on 25/03/23.
//

import Foundation
struct JobsModel: Decodable {
    var success: Bool?
    var invitationsCount:Int?
    var jobsCount:Int?
    var pageNumber:Int?
    var pageSize: Int?
    var data: ProfileData?
}

struct JobsData: Decodable {
    var jobs: [Job]?
    var jobInviations: [JobInviation]?
}

struct Job: Decodable {
    var location:Location?
    let _id: String?
    let customer: Customer?
    let partners: [Partner]?
    let description: String
    let type: String
    let category: Category
    let service: Service
    let urgency: String
    var images: [String]
    let status: String
    let createdDate: Bool
}

struct Customer: Decodable {
    let fullName : String
    let mobileNumber : String
    let emailAddress : String
}

struct Partner: Decodable {
    let emailAddress : String
    let mobileNumber : String
    let profilePhoto : String
}

struct Category: Decodable {
    let _id : String
    let categoryName : String
    let categoryCode : String
    let isActive : Bool
    let isPopular : Bool
    let createdDate : String
    let lastUpdatedDate : String
    let categoryImage : String
}

struct Service: Decodable {
    let _id : String
    let serviceName : String
    let category : String
    let isActive : Bool
    let createdDate : String
    let lastUpdatedDate : String
}

struct JobInviation: Decodable {
    let _id: String?
    let job: NewJob?
}


struct NewJob: Decodable {
    let location: Location?
    let _id: String?
    let customer: String?
    let partners: [String]?
    let description: String
    let type: String
    var category: String?
    var service: String?
    let urgency: String
    var images: [String]
    var address:String
    let status: Bool
    let markedAsCompleteByPartner:Bool
    let createdDate: String
    let lastUpdatedDate:String
}

