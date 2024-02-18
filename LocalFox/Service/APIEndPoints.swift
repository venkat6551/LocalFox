//
//  APIEndPoints.swift
//  LocalFox
//
//  Created by venkatesh karra on 03/02/23.
//

import Foundation
enum APIEndpoints {
    
    static var BASE_URL = "https://api.localfox.com.au"
    
    //LOGIN
    static var AUTHENTICATE_USER = BASE_URL + "/v1/partner/authenticate"
    static var LOGOUT = BASE_URL + "/v1/partner/logout"
    
    //REGISTRATION
    static var SEND_MOBILE_CODE = BASE_URL + "/v1/partner/verification/sendMobileCode"
    static var VALIDATEMOBILE_CODE = BASE_URL + "/v1/partner/verification/validateMobileCode"
    static var SEND_EMAIL_CODE = BASE_URL + "/v1/partner/verification/sendEmailCode"
    static var VALIDATE_EMAIL_CODE = BASE_URL + "/v1/partner/verification/validateEmailCode"
    static var REGISTRATION_PARTNER = BASE_URL + "/v1/partner/registerPartner"
    
    //RESET PASSWORD
    static var RESET_PASSWORD = BASE_URL + "/v1/partner/resetPassword"
    static var VALIDATE_RESET_PASSWORD_CODE = BASE_URL + "/v1/partner/verification/validateResetPasswordCode"
    static var SET_NEW_PASSWORD = BASE_URL + "/v1/partner/setNewPassword"
    
    
    //FCM TOKEN
    static var REGISTER_FCM_TOKEN = BASE_URL + "/v1/partner/fcmToken/registerFcmToken"
    static var LINK_USER_TO_FCM_TOKEN = BASE_URL + "/v1/partner/fcmToken/linkPartner"
    
    //PROFILE SETTINGS
    static var GET_PROFILE = BASE_URL + "/v1/partner/profile/getProfile"
    static var UPLOAD_PROFILE_PHOTO = BASE_URL + "/v1/partner/profile/uploadProfilePhoto"
    static var DELETE_PROFILE_PHOTO = BASE_URL + "/v1/partner/profile/deleteProfilePhoto"
    static var UPDATE_MOBILE_NUMBER = BASE_URL + "/v1/partner/profile/updateMobileNumber"
    static var UPDATE_ADDRESS = BASE_URL + "/v1/partner/profile/updateAddress"
    static var UPDATE_NOTIFICATION_SETTINGS = BASE_URL + "/v1/partner/profile/updateNotificationSettings"
    
    //JOBS
    static var GET_JOBS = BASE_URL + "/v1/partner/jobs/getJobs"
    static var ASSIGN_JOB_TO_EMPLOYEE = BASE_URL + "/v1/customer/authenticate"
    static var GET_JOB_DETAILS = BASE_URL + "/v1/partner/jobs/getJobDetails"
    static var MARK_JOB_AS_COMPLETE = BASE_URL + "/v1/partner/jobs/markJobAsComplete/"
    
    //quote
    static var CREATE_QUOTE = BASE_URL + "/v1/partner/quotes/createJobQuote"
    static var SAVE_QUOTE = BASE_URL + "/v1/partner/quotes/saveQuote"
    static var SEND_QUOTE = BASE_URL + "/v1/partner/quotes/sendQuote"
    static var CANCEL_QUOTE = BASE_URL + "/v1/partner/quotes/cancelQuote/"
    
    static var CREATE_INVOICE = BASE_URL + "/v1/partner/invoices/createJobInvoice"
    static var SEND_INVOICE = BASE_URL + "/v1/partner/invoices/sendInvoice"
    static var SAVE_INVOICE = BASE_URL + "/v1/partner/invoices/saveInvoice"
    static var CONVERT_TO_INVOICE = BASE_URL + "/v1/partner/invoices/createInvoiceFromQuote"
    static var CANCEL_INVOICE = BASE_URL + "/v1/partner/invoices/cancelInvoice/"
    
    //JOB INVITATION
    static var ACCEPT_INVITATION = BASE_URL + "/v1/partner/jobs/acceptJob/"
    static var REJECT_INVITATION = BASE_URL + "/v1/partner/jobs/declineJob/"
    static var ADD_JOB_NOTES = BASE_URL + "/v1/partner/jobActivity/addJobNotes"

    //SCHEDULES
    static var GET_SCHEDULES = BASE_URL + "/v1/partner/schedule/getSchedules"
    static var DELETE_SCHEDULE = BASE_URL + "/v1/partner/schedule/deleteSchedule"
    static var CREATE_SCHEDULE = BASE_URL + "/v1/partner/schedule/createSchedule"
}
