//
//  NotificationSettingsView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 1/14/23.
//

import SwiftUI

struct NotificationSettingsView: View {
    @StateObject var profileVM: ProfileViewModel
    @State private var pushNotificationOn = true
    @State private var smsNotificationOn = true
    @State private var emailiNotificationOn = true
    @State private var announcementsNotificationOn = true
    @State private var eventsNotificationOn = true
    @State private var showErrorSnackbar: Bool = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
            ToggleView(settingsType: $pushNotificationOn, title: Strings.PUSH_NOTIFICATIONS, leadingImage: Images.PUSH_NOTIFCATION_ICON).padding(.top, 20)
            ToggleView(settingsType: $smsNotificationOn, title: Strings.SMS_NOTIFICATIONS, leadingImage: Images.SMS_NOTIFCATION_ICON)
            ToggleView(settingsType: $emailiNotificationOn, title: Strings.EMAIL_NOTIFICATIONS, leadingImage: Images.EMAIL_NOTIFCATION_ICON)
            ToggleView(settingsType: $announcementsNotificationOn, title: Strings.ANNOUNCEMENTS, leadingImage: Images.ANNOUNCEMENTS_ICON)
            ToggleView(settingsType: $eventsNotificationOn, title: Strings.EVENTS, leadingImage: Images.EVENTS_NOTIFCATION_ICON)
            
            MyButton(
                text: Strings.UPDATE_SETTINGS,
                onClickButton: {
                    if(pushNotificationOn != profileVM.profileModel?.data?.NotificationSettings.pushNotifications
                       || smsNotificationOn != profileVM.profileModel?.data?.NotificationSettings.smsNotifications
                       || emailiNotificationOn != profileVM.profileModel?.data?.NotificationSettings.emailNotifications
                       || announcementsNotificationOn != profileVM.profileModel?.data?.NotificationSettings.announcements
                       || eventsNotificationOn != profileVM.profileModel?.data?.NotificationSettings.events) {
                        
                        profileVM.updateNotificationSettings(pushNotifications: pushNotificationOn, smsNotifications: smsNotificationOn, emailNotifications: emailiNotificationOn, announcements: announcementsNotificationOn, events: eventsNotificationOn)

                    } else {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                },
                bgColor: Color.PRIMARY
            ).padding(.top, 50)
            Spacer()
        }
        .onAppear{
            if let pushNotification =  profileVM.profileModel?.data?.NotificationSettings.pushNotifications,
               let smsNotification =  profileVM.profileModel?.data?.NotificationSettings.smsNotifications,
               let emailiNotification =  profileVM.profileModel?.data?.NotificationSettings.emailNotifications,
               let announcementsNotification =  profileVM.profileModel?.data?.NotificationSettings.announcements,
               let eventsNotification =  profileVM.profileModel?.data?.NotificationSettings.events {
                pushNotificationOn = pushNotification
                smsNotificationOn = smsNotification
                emailiNotificationOn = emailiNotification
                announcementsNotificationOn = announcementsNotification
                eventsNotificationOn = eventsNotification
            }
            profileVM.updateNotificationSettingsSuccess = false
            profileVM.errorString = nil
            showErrorSnackbar = false
        }
        .padding(.horizontal,20)
        .setNavTitle(Strings.NOTIFICATIONS, showBackButton: true,leadingSpace: 20)
        .snackbar(
            show: $showErrorSnackbar,
            snackbarType: profileVM.updateNotificationSettingsSuccess == false ? SnackBarType.error : SnackBarType.success,
            title: profileVM.updateNotificationSettingsSuccess == false ? "Error" : "Success",
            message: profileVM.errorString,
            secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
            onSnackbarDismissed: {
                self.presentationMode.wrappedValue.dismiss()
                showErrorSnackbar = false },
            isAlignToBottom: true
        )
        .onChange(of: profileVM.isLoading) { isloading in
            if profileVM.updateNotificationSettingsSuccess == true  && profileVM.errorString != nil {
                showErrorSnackbar = true
            } else
            if(profileVM.updateNotificationSettingsSuccess == false && profileVM.errorString != nil) {
                showErrorSnackbar = true
            }
        }
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
                .padding(.vertical,15)
                .padding(.horizontal,5)
        }.cardify()
    }
}
struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView(profileVM: ProfileViewModel())
    }
}
