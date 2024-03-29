//
//  Images.swift
//  Hapag-Lloyd
//
//  Easily access all Assets
//
//  Created by Meet Vora on 2022-07-15.
//

import Foundation
import SwiftUI

enum Images {
    
    static let INVOICED_FILTER_ICON = Image("invoicedFilterIcon")
    static let LOCAL_FOX = Image("local_fox")
    static let PARTNER = Image("partner")
    static let ERROR = Image(systemName: "xmark")
    static let CHECKMARK_ROUNDED = Image(systemName: "checkmark.circle.fill")
    static let EYE_SLASH = Image(systemName: "eye.slash")
    static let EYE = Image(systemName: "eye")
    static let WARNING_ROUNDED = Image(systemName: "exclamationmark.circle.fill")
    static let SEARCH = Image("search")
    static let BACK = Image("BackArrowCircle")
    static let FILTER = Image("filter")
    static let LOCATION_PIN = Image("Locationpin")
    static let CHECKMARK = Image("CheckMark")
    static let LEADS_TAB = Image("leadsTabIcon")
    static let PROFILE_TAB = Image("profileTabIcon")
    static let SCHEDULE_TAB = Image("Beaker")
    static let CLOSE = Image("Close")
    static let CALL = Image("call")
    static let PROFILE = Image("profile")
    static let GREEN_CHECK = Image("GreenCheck")
    static let DISCLOSURE = Image("Disclosure")
    static let CALL_BUTTON = Image("CallButton")
    static let EMAIL_BUTTON = Image("EmailButton")
    static let LOCATION_BUTTON = Image("LocationButton")
    static let CAMERA_ICON = Image("camera")
    static let DESCRIPTION_ICON = Image("description")
    static let TIME_ICON = Image("time")
    static let WHITE_TICK = Image("Whitetick")
    static let EXPIRED_FILTER = Image("ExpiredFilter")
    static let SCHEDULED_FILTER = Image("ScheduledFilter")
    static let COMPLETED_FILTER = Image("CompletedFilter")
    static let QUOTED_FILTER = Image("QuotedFilter")
    static let ACTIVE_FILTER = Image("ActiveFilter")
    static let TANDC_ICON = Image("TandCIcon")
    static let SECURITY_ICON = Image("SecurityIcon")
    static let PROFILE_ICON = Image("ProfileIcon")
    static let PRIVACY_ICON = Image("PrivacyStmtIcon")
    static let NOTIFICATION_ICON = Image("NotificationIcon")
    static let LEGAL_DISCLOSURE = Image("LegalDisclosure")
    static let EVENTS_NOTIFCATION_ICON = Image("events")
    static let ANNOUNCEMENTS_ICON = Image("announcements")
    static let EMAIL_NOTIFCATION_ICON = Image("emailNotificationIcon")
    static let SMS_NOTIFCATION_ICON = Image("smsNotificationIcon")
    static let PUSH_NOTIFCATION_ICON = Image("pushNotificationIcon")
    static let FACE_ID = Image("faceID")
    static let CHANGE_PIN = Image("changePin")
    static let SET_PIN = Image("setPin")
    static let CHECK_CIRCLE = Image("Checkcircle")
    static let FLAG = Image("flag")
    static let SEARCH_TAB = Image("SearchTab")
    static let SUCCESS_TICK = Image("SuccessTick")
    static let ERROR_TICK = Image("ErrorTick")
    static let INFO_ICON = Image("InfoIcon")
    static let LOGOUT = Image("logout")
    static let WARNING_TRIANGLE = Image("warning_triangle")
    static let LOCATION_NEW = Image("Location_new")
    static let INVOICED_FILTER = Image("Invoiced_Filter")
    static let ASSIGNED_FILTER = Image("Assigned_Filted")
    static let RED_CHECK = Image("Red_check")
    static let JOB_SUMMARY = Image("jobSummaryicon")
    static let NOTES_ICON = Image("NotesIcon")
    static let SCHEDULE_ICON = Image("scheduleIcon")
    
    static let CALL_ACT_ICON = Image("call_activity")
    static let COMPLETE_ACT_ICON = Image("complete_activity")
    static let PAYMENT_ACT_ICON = Image("payment_activity")
    static let SMS_ACT_ICON = Image("sms_activity")
    static let NOTES_ACT_ICON = Image("notes_activity")
    static let QUOTE_ACT_ICON = Image("quote_activity")
    static let SCHEDULE_ACT_ICON = Image("schedule_activity")
    static let INVOICE_ADD_ICON = Image("invoice_add")
    static let NOTES_ADD_ICON = Image("notes_add")
    static let QUOTE_ADD_ICON = Image("quote_add")
    static let SCHEDULE_ADD_ICON = Image("schedule_add")
    static let PLUS_ICON = Image("plus")
    static let DOLLAR = Image("dollar")
    static let RED_CLOSE_ROUND = Image("RedCloseRound")
   }

// A place to test your images
struct Images_Previews: PreviewProvider {
    
    // Object in the preview are smaller than they appear
    // I mean I am resizing images inside preview. You can resize them according to your needs
    private static let previewImages: [Image] = [
        Images.LOCAL_FOX,
        Images.PARTNER,
        
    ]
    
    static var previews: some View {
        ScrollView {
            VStack() {
                ForEach((0...(previewImages.count-1)), id: \.self) {
                    previewImages[$0]
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                }
            }
            .padding()
        }
        .background(Color.blue)
        .previewDevice("iPhone Xs")
    }
}
