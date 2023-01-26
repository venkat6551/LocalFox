//
//  SecuritySettingsView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 1/14/23.
//

import SwiftUI

struct SecuritySettingsView: View {
    @State private var setPinOn = true
    @State private var enableFaceeIdOn = false
    @State private var showSettingsUpdateSheet = false
    @State private var pin: String = "1234"
    var body: some View {
        
        ZStack {
            VStack {
                ToggleView(settingsType: $setPinOn, title: Strings.SET_PIN_TEXT, leadingImage: Images.SET_PIN)
                ProfileRowView(title: Strings.CHANGE_PIN_TEXT, leadingImage: Images.CHANGE_PIN,trailingimage: Images.DISCLOSURE) {
                    showSettingsUpdateSheet = true
                }
                ToggleView(settingsType: $enableFaceeIdOn, title: Strings.FACE_ID_TEXT, leadingImage: Images.FACE_ID)
                Spacer()
            }.padding(20)
        }
        .background(Color.SCREEN_BG.ignoresSafeArea())
        .setNavTitle(Strings.SECURITY, showBackButton: true,leadingSpace: 20)
        .sheet(isPresented: $showSettingsUpdateSheet){
            SettingsUpdateSheet(onClickClose: {
            }, settingsType: SettingsType.pin,text: $pin)
        }
    }
}

struct SecuritySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SecuritySettingsView()
    }
}
