//
//  ProfileSettingsView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 1/14/23.
//

import SwiftUI

struct ProfileSettingsView: View {
    @State private var pushNotificationOn = true
    @State private var marketingNotificationOn = true
    @State private var showSettingsUpdateSheet = false
    @State private var mobileNumText: String = "+61 484 484 484"
    @State private var emailText: String = "Rajesh.Mekala@localfox.au"
    @State private var addressText: String = "31 Barrallier Drive\nMarsden Park NSW 2765"
    @State private var settingsType: SettingsType = SettingsType.mobileNumber
    
    @State private var changeText: String = ""
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(Strings.EMAIL_ADDRESS).applyFontRegular(color: .TEXT_LEVEL_3,size: 13).padding(.top,20).padding(.leading,20)
                HStack {
                    Text($emailText.wrappedValue).applyFontRegular(color: .DEFAULT_TEXT,size: 14)
                    
                    Images.GREEN_CHECK
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
                            showSettingsUpdateSheet = true
                        },
                        label: {
                            Text(Strings.UPDATE).applyFontRegular(color: .PRIMARY, size: 12)
                        }
                    )
                }.padding(.top,20).padding(.horizontal,20)
                
                HStack {
                    Text($mobileNumText.wrappedValue).applyFontRegular(color: .DEFAULT_TEXT,size: 14)
                    
                    Images.GREEN_CHECK
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
                            showSettingsUpdateSheet = true
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
        .padding(.horizontal,20)
        .setNavTitle(Strings.PROFILE_SETTINGS, showBackButton: true,leadingSpace: 20)
        .sheet(isPresented: $showSettingsUpdateSheet){
            SettingsUpdateSheet(onClickClose: {
            }, settingsType: settingsType,text: $changeText)
        }
    }
}

struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView()
    }
}
