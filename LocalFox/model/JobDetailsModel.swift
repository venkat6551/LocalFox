//
//  JobDetailsModel.swift
//  Local Fox
//
//  Created by venkatesh karra on 16/11/23.
//

import Foundation

struct JobDetailsModel: Decodable {
    var success: Bool?
    var data: JobDataModel?
}

struct JobDataModel: Decodable {
    var job: Job
    var jobActivities: [ActivityModel]?
    var quotes: [QuoteModel]?
    var invoices: [InvoiceModel]?
//    var schedules: [Schedule]?
}

struct ActivityModel: Decodable {
    let _id: String
    let job: String
    let partner: String
    let activityType: String
    let activityDescription: String
    let createdDate: String
    let lastUpdatedDate: String
    let notes: String?
    let invoice: ActivityInVoiceModel?
    let quote: ActivityQuoteeModel?
}

struct ActivityInVoiceModel: Decodable {
    let _id: String
    let invoiceReference: String
    let totalPrice: Float
    let createdDate: String
}

struct ActivityQuoteeModel: Decodable {
    let _id: String
    let quoteReference: String
    let createdDate: String
    let quoteExpiry: String
    let totalPrice: Float
}

struct NewQuoteModel: Decodable {
    var success: Bool?
    var data: QuoteModel
}

struct QuoteModel: Decodable {
    let _id: String
    let quoteReference: String
    let quoteStatus: String
    let partner: QuotePartnerModel
    let contact: Customer?
    let customer: Customer?
    let job: String
    let quoteExpiry: String
    let createdDate: String
    let lastUpdatedDate: String
    let subTotal: Float?
    let totalPrice: Float?
    let totalTax: Float?
    var items: [QuoteItemModel]
}

struct QuotePartnerModel: Decodable {
    let _id: String
    let location: Location
    let emailAddress: String
    let firstName: String
    let isMobileVerified: Bool
    let lastName: String
    let mobileNumber: String
    let profilePhoto: String
}

struct QuoteItemModel: Decodable {
    let _id: String?
    let serviceName: String
    let serviceDescription: String
    let price: Float
    var tax: Float = 0
    let taxType: String
    let totalItemPrice: Float
}

struct InvoiceModel: Decodable {
    let _id: String
    let invoiceReference: String
    let invoiceStatus: String
    let partner: QuotePartnerModel
    let contact: Customer
    let job: String
    let items: [QuoteItemModel]
    var subTotal: Float?
    var totalPrice: Float?
    var totalTax: Float? 
    let invoiceDueDate: String
    let paymentStatus: String
    let quote: String?
    let creationMode: String
    let createdDate: String
    let lastUpdatedDate: String
}

struct Schedule: Decodable {
    let _id: String
    let partner: Partner
    let job: ScheduleJobModel
    let date: String
    let startTime: String
    let endTime: String
    let isActive: Bool
    let createdDate: String
    let lastUpdatedDate: String
}

struct ScheduleJobModel: Decodable {
    var location:Location
    let _id: String
}


