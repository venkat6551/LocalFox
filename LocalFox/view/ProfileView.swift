//
//  ProfileView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 12/9/22.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Profile").applyFontHeader()
                    Spacer()

                }
                ProfileCardView().cardify()
                HStack {
                    Text("Settings").applyFontBold(size: 20)
                    Spacer()
                }
                .padding(.top,10)
                .padding(.bottom,10)
                SettingsView().cardify()
                HStack {
                    Text("Legal").applyFontBold(size: 20)
                    Spacer()
                }
                .padding(.top,10)
                .padding(.bottom,10)
                ContactDetailsView().cardify()
                Text("App version. 1.20.42325").applyFontRegular(color: Color.TEXT_LEVEL_3,size: 12).padding(.top,25)

                Button(
                    action: {
                        self.presentationMode.wrappedValue.dismiss() // Go back
                    },
                    label: {
                        Text("Logout").applyFontRegular(size: 12)
                            .padding(5)
                            .padding(.horizontal,10)
                    }
                ).cardify(cardBgColor: Color.LIGHT_GRAY)

            }
            Spacer()
        }
        .navigationBarHidden(true)
        .padding(.horizontal,25)
        .padding(.top,25)
        .background(Color.SCREEN_BG.ignoresSafeArea())
    }
    
    struct ProfileCardView: View {
        var body: some View {
            ZStack {
                VStack(alignment: .leading) {
                    HStack  {
                        VStack {
                            Images.PROFILE
                                .foregroundColor(Color.BLUE)
                        }.cardify()
                        VStack {
                            HStack(spacing: 0) {
                                Text("Alex Eadie")
                                    .applyFontBold(size: 16)
                                Images.GREEN_CHECK.padding(.leading,5)
                                Spacer()
                            }.padding(.top, 5)
                            
                            HStack {
                                Text("PLUMBER")
                                    .applyFontBold(color:Color.TEXT_GREEN, size: 14)
                                Spacer()
                            }
                            HStack{
                                Images.LOCATION_PIN
                                    .frame(width: 15)
                                Text("Marsden Park, NSW 2765")
                                    .applyFontRegular(size: 13)
                                Spacer()
                            }
                        }
                    }
                }.padding(15)
            }
        }
    }
    
    struct SettingsView: View {
        
        @State private var showProfileSettings = false
        @State private var showNotificationSettings = false
        @State private var showSecuritySettings = false
        var body: some View {
            ZStack {
                VStack(alignment: .leading) {
                    ProfileRowView(title: "Profile settings", leadingImage: Images.PROFILE_ICON, trailingimage: Images.DISCLOSURE){
                        showProfileSettings = true
                    }
                    ProfileRowView(title: "Notifications", leadingImage: Images.NOTIFICATION_ICON, trailingimage: Images.DISCLOSURE){
                        showNotificationSettings = true
                    }
                    ProfileRowView(title: "Security", leadingImage: Images.SECURITY_ICON, trailingimage: Images.DISCLOSURE){
                        showSecuritySettings = true
                    }
                }
                .navigationDestination(isPresented: $showProfileSettings) {
                    ProfileSettingsView()
                }
                .navigationDestination(isPresented: $showNotificationSettings) {
                    NotificationSettingsView()
                }
                .navigationDestination(isPresented: $showSecuritySettings) {
                    SecuritySettingsView()
                }
            }
            .background(Color.SCREEN_BG)
        }
    }
    struct ContactDetailsView: View {
        @State private var pushNotificationOn = true
        @State private var marketingNotificationOn = true
        var body: some View {
            ZStack {
                VStack(alignment: .leading) {
                    ProfileRowView(title: "Privacy statement", leadingImage: Images.PRIVACY_ICON, trailingimage: Images.LEGAL_DISCLOSURE) {
                        
                    }
                    
                    ProfileRowView(title: "Terms and conditions", leadingImage: Images.TANDC_ICON, trailingimage: Images.LEGAL_DISCLOSURE){
                        
                    }
                }
            }.background(Color.SCREEN_BG)
        }
    }
}

struct ProfileRowView: View {
    var title: String
    var leadingImage: Image?
    var trailingimage: Image?
    var onRowClick: () -> Void
    var body: some View {
        
        ZStack {
            HStack {
                if let leadingImage = leadingImage {
                    leadingImage
                        .padding(.trailing,5)
                }
                Text(title).applyFontRegular(size: 14)
                Spacer()
                
                if let trailingimage = trailingimage {
                    trailingimage
                    
                }
            } .padding(15).cardify()
        }
        .contentShape(Rectangle())
            .frame(maxWidth: .infinity)
            .onTapGesture {
                onRowClick()
            }
        
    }
}

struct ColoredToggleStyle: ToggleStyle {
    var label = ""
    var onColor = Color(UIColor.green)
    var offColor = Color(UIColor.systemGray5)
    var thumbColor = Color.white
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Text(label).applyFontRegular(size: 14)
            Spacer()
            Button(action: { configuration.isOn.toggle() } )
            {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: 50, height: 29)
                    .overlay(
                        Circle()
                            .fill(thumbColor)
                            .shadow(radius: 1, x: 0, y: 1)
                            .padding(1.5)
                            .offset(x: configuration.isOn ? 10 : -10))
                    .animation(Animation.easeInOut, value: 0.1)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15.0)
                            .stroke(Color.LINES, lineWidth: Dimens.INPUT_FIELD_BOX_OUTLINE_WIDTH)
                    )
            }
        }
        .font(.title)
    }
}
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
