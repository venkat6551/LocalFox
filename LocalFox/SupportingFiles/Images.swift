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
