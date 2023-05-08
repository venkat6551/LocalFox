//
//  JobModel.swift
//  LocalFox
//
//  Created by venkatesh karra on 25/03/23.
//

import Foundation
struct JobsModel: Decodable {
    var success: Bool?
    var invitationsCount:Int
    var jobsCount:Int
    var pageNumber:Int
    let pageSize: Int
    var data: JobsData?
}

struct JobsData: Decodable {
    var jobs: [Job]?
    var jobInviations: [JobInviation]?
}

struct Job: Decodable,Identifiable,Hashable {
    var id: String {
        return _id!
    }
    
    public func hash(into hasher: inout Hasher) {
            hasher.combine(_id)
        }
    static func ==(left:Job, right:Job) -> Bool {
        return left._id == right._id
    }
    
    var location:Location?
    let _id: String?
    let customer: Customer?
    let partners: [Partner]?
    let description: String
    let type: String
    var category: Category?
    var service: Service?
    let urgency: String
    var images: [String]
    var address: String?
    let status: String
    let createdDate: String
}

struct Customer: Decodable {
    let fullName : String?
    let mobileNumber : String?
    let emailAddress : String?
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

struct JobInviation: Decodable,Identifiable,Hashable {
    var id: String {
        return _id!
    }
    var hashValue: Int { get { return _id.hashValue } }
    let _id: String?
    let job: NewJob?
    public func hash(into hasher: inout Hasher) {
            hasher.combine(_id)
        }
    static func ==(left:JobInviation, right:JobInviation) -> Bool {
        return left._id == right._id
    }
}


struct NewJob: Decodable {
    let location: Location?
    let _id: String?
     let description: String
    let type: String
    var category: String?
    var service: Service?
    let urgency: String
    var images: [String]
    var address:String
    let status: String
    let markedAsCompleteByPartner:Bool
    let createdDate: String
    let lastUpdatedDate:String
}
