//
//  SchedulesModel.swift
//  Local Fox
//
//  Created by venkatesh karra on 08/02/24.
//

import Foundation

struct SchedulesModel: Decodable {
    var success: Bool
    var data: [ScheduleModel]?
}

struct ScheduleModel: Decodable,Identifiable,Hashable  {
    var id: String {
        return _id
    }
    
    public func hash(into hasher: inout Hasher) {
            hasher.combine(_id)
        }
    static func == (left:ScheduleModel, right:ScheduleModel) -> Bool {
        return left._id == right._id
    }
    
    let _id : String
   // let partner : String
    let date : String
    let startTime: String
    let endTime: String
    let isActive: Bool
    let createdDate:String
    let lastUpdatedDate: String
    let job: SchedulesJob?
}
struct SchedulesJob: Decodable {
    var id: String {
        return _id!
    }
    var location:Location?
    let _id: String?
    let contact: Customer?
    let customer: Customer?
    let status: String?
    let jobTitle: String
    let createdDate: String
    
    func getUser() -> Customer? {
        if let user = self.customer {
            return user
        }
        if let user = self.contact {
            return user
        }
        return nil
    }
    
    func getFormattedLocation() -> String {
        
        var location = ""
        
        if let streenNum = self.location?.streetNumber {
            location = streenNum
        }
        if let streenName = self.location?.streetName {
            location = "\(location) \(streenName)"
        }
        
        if location.count > 0 {
            location = "\(location) \n"
        }
        
        if let suburb = self.location?.suburb {
            location = "\(location)\(suburb)"
        }
        if let state = self.location?.state {
            location = "\(location) \(state)"
        }
        
        if let postCode = self.location?.postCode {
            location = "\(location) \(postCode)"
        }
        
        return location
    }
    
    func getShortFormattedLocation() -> String {
        
        var location = ""
        
        if let suburb = self.location?.suburb {
            location = "\(location)\(suburb), "
        }
        if let state = self.location?.state {
            location = "\(location)\(state) "
        }
        
        if let postCode = self.location?.postCode {
            location = "\(location)\(postCode)"
        }
        
        return location
    }
}
