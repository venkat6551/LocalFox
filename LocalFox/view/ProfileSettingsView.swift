//
//  ProfileSettingsView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 1/14/23.
//

import SwiftUI

struct ProfileSettingsView: View {
    @StateObject var profileVM: ProfileViewModel
    @State private var pushNotificationOn = true
    @State private var marketingNotificationOn = true
    @State private var showMobileSettingsUpdateSheet = false
    
    @State private var showAddressSettingsUpdateSheet = false
    
    
    @State private var mobileNumText: String = ""
    @State private var emailText: String = ""
    @State private var addressText: String = ""
    @State private var settingsType: SettingsType = SettingsType.mobileNumber
    
    @State private var changeText: String = ""
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(Strings.EMAIL_ADDRESS).applyFontRegular(color: .TEXT_LEVEL_3,size: 13).padding(.top,20).padding(.leading,20)
                HStack {
                    Text($emailText.wrappedValue).applyFontRegular(color: .DEFAULT_TEXT,size: 14)
                    if  profileVM.profileModel?.data?.isEmailVerified == true {
                        Images.GREEN_CHECK
                    }
                    Spacer()
                }
                .padding(.bottom,20).padding(.leading,20)
            }.cardify().padding(.top,20)
            VStack(alignment: .leading) {
                HStack {
                    Text(Strings.MOBILE_NUMBER).applyFontRegular(color: .TEXT_LEVEL_3,size: 13)
                    Spacer ()
                    Button(
                        action: {
                            changeText = mobileNumText
                            settingsType = SettingsType.mobileNumber
                            showMobileSettingsUpdateSheet = true
                        },
                        label: {
                            Text(Strings.UPDATE).applyFontRegular(color: .PRIMARY, size: 12)
                        }
                    )
                }.padding(.top,20).padding(.horizontal,20)
                
                HStack {
                    Text($mobileNumText.wrappedValue).applyFontRegular(color: .DEFAULT_TEXT,size: 14)
                    if  profileVM.profileModel?.data?.isMobileVerified == true {
                        Images.GREEN_CHECK
                    }
                    Spacer()
                }
                .padding(.bottom,20).padding(.leading,20)
            }.cardify()
            VStack(alignment: .leading) {
                HStack {
                    Text(Strings.ADDRESS).applyFontRegular(color: .TEXT_LEVEL_3,size: 13)
                    Spacer ()
                    Button(
                        action: {
                            changeText = addressText
                            settingsType = SettingsType.address
                            showAddressSettingsUpdateSheet = true
                        },
                        label: {
                            Text(Strings.UPDATE).applyFontRegular(color: .PRIMARY, size: 12)
                        }
                    )
                }.padding(.top,20).padding(.horizontal,20)
                
                HStack {
                    Text($addressText.wrappedValue).applyFontRegular(color: .DEFAULT_TEXT,size: 14)
                    Spacer()
                }
                .padding(.bottom,20).padding(.leading,20).padding(.top,5)
            }.cardify()
            Spacer()
        }
        .onAppear{
            mobileNumText = (self.profileVM.profileModel?.data?.mobileNumber ?? "")
            emailText = (self.profileVM.profileModel?.data?.emailAddress ?? "")
            addressText = (self.profileVM.profileModel?.data?.getFormattedLocation() ?? "")
        }
        .padding(.horizontal,20)
        .setNavTitle(Strings.PROFILE_SETTINGS, showBackButton: true,leadingSpace: 20)
        .sheet(isPresented: $showMobileSettingsUpdateSheet){
            SettingsUpdateSheet(onClickClose: {
            }, profileVM: profileVM, onUpdateSuccess: {
                addressText = (self.profileVM.profileModel?.data?.getFormattedLocation() ?? "")
            }, settingsType: SettingsType.mobileNumber, text: $changeText)
        }
        .sheet(isPresented: $showAddressSettingsUpdateSheet){
            SettingsUpdateSheet(onClickClose: {
            }, profileVM: profileVM, onUpdateSuccess: {
                addressText = (self.profileVM.profileModel?.data?.getFormattedLocation() ?? "")
            }, settingsType: SettingsType.address, text: $changeText)
        }
    }
}

struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView(profileVM: ProfileViewModel())
    }
}
