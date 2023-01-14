//
//  NotificationSettingsView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 1/14/23.
//

import SwiftUI

struct NotificationSettingsView: View {
    @State private var pushNotificationOn = true
    @State private var smsNotificationOn = true
    @State private var emailiNotificationOn = true
    @State private var announcementsNotificationOn = true
    @State private var eventsNotificationOn = true
    var body: some View {
        VStack {            
            ToggleView(settingsType: $pushNotificationOn, title: "Push Notifocations", leadingImage: Images.PUSH_NOTIFCATION_ICON).padding(.top, 20)
            ToggleView(settingsType: $smsNotificationOn, title: "SMS Notifications", leadingImage: Images.SMS_NOTIFCATION_ICON)
            ToggleView(settingsType: $emailiNotificationOn, title: "Email Notifications", leadingImage: Images.EMAIL_NOTIFCATION_ICON)
            ToggleView(settingsType: $announcementsNotificationOn, title: "Announcements", leadingImage: Images.ANNOUNCEMENTS_ICON)
            ToggleView(settingsType: $eventsNotificationOn, title: "Events", leadingImage: Images.EVENTS_NOTIFCATION_ICON)
            Spacer()

        }
        .padding(.horizontal,20)
        .setNavTitle("Notifications", showBackButton: true)
    }   
}
struct ToggleView: View {
    @Binding var settingsType: Bool
    var title:String
    var leadingImage:Image
    var body: some View {
        HStack {
            leadingImage
                .padding(.leading,15)
        Toggle("", isOn: $settingsType)
                                .toggleStyle(
                                    ColoredToggleStyle(label: title,
                                                       onColor: .PRIMARY,
                                                       thumbColor: .white))
                                .padding(10)
        }.cardify()
    }
}
struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView()
    }
}
