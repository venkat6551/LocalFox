//
//  ProfileView.swift
//  LocalFox
//
//  Created by Venkatesh karra on 12/9/22.
//

import SwiftUI

struct ProfileView: View {
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    @State private var showProfilePhotoView = false
    @StateObject var profileVM: ProfileViewModel
    @State var imageSelected = UIImage()
    @State private var photoSelectedFromCam = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(Strings.PROFILE).applyFontHeader()
                    Spacer()
                }
                ProfileCardView(profileVM: profileVM) {
                    if(profileVM.profileModel?.data?.profilePhoto != nil && profileVM.profileModel?.data?.profilePhoto != Strings.NO_PROFILE_PIC){
                        self.showProfilePhotoView = true
                    } else {
                        self.shouldPresentActionScheet = true
                    }
                }.cardify()
                ScrollView {
                    HStack {
                        Text(Strings.SETTINGS).applyFontBold(size: 20)
                        Spacer()
                    }
                    .padding(.top,10)
                    .padding(.bottom,10)
                    SettingsView(profileVM: profileVM).cardify()
                    HStack {
                        Text(Strings.LEGAL).applyFontBold(size: 20)
                        Spacer()
                    }
                    .padding(.top,10)
                    .padding(.bottom,10)
                    LegalsView().cardify()
                    Text("App version. 1.20.42325").applyFontRegular(color: Color.TEXT_LEVEL_3,size: 12).padding(.top,25)
                    Button(
                        action: {
                            profileVM.logoutUser()
                            self.presentationMode.wrappedValue.dismiss() // Go back
                        },
                        label: {
                            Text(Strings.LOGOUT).applyFontRegular(size: 12)
                                .padding(5)
                                .padding(.horizontal,10)
                        }
                    ).cardify(cardBgColor: Color.LIGHT_GRAY)
                }
            }
            Spacer()
        }
        .navigationBarHidden(true)
        .padding(.horizontal,25)
        .padding(.top,25)
        .background(Color.SCREEN_BG.ignoresSafeArea())
        .sheet(isPresented: $shouldPresentImagePicker) {
            ImagePicker(selectedImage: $imageSelected, sourceType: self.shouldPresentCamera ? .camera : .photoLibrary,onPhotoSelected: {
                self.photoSelectedFromCam = true
            })
        }
        .actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
            ActionSheet(title: Text(Strings.IMAGE_PICKER_TITLE), message: Text(Strings.IMAGE_PICKER_DESCRIPTION), buttons: [ActionSheet.Button.default(Text(Strings.CAMERA), action: {
                self.shouldPresentImagePicker = true
                self.shouldPresentCamera = true
            }), ActionSheet.Button.default(Text(Strings.PHOTO_LIBRARY), action: {
                self.shouldPresentImagePicker = true
                self.shouldPresentCamera = false
            }), ActionSheet.Button.cancel()])
        }
        .navigationDestination(isPresented: $showProfilePhotoView) {
            ProfileImageView(profileVM: profileVM)
        }
        .navigationDestination(isPresented: $photoSelectedFromCam) {
            ImagePreview(profileVM: profileVM, imageSelected: imageSelected)
        }
    }
    
    struct ProfileCardView: View {
        @StateObject var profileVM: ProfileViewModel
        @State var reloadViews = false
        var onProfilePicClick: () -> Void
        var body: some View {
            ZStack {
                VStack(alignment: .leading) {
                    HStack  {
                        VStack {
                            if(profileVM.profileModel?.data?.profilePhoto != nil && profileVM.profileModel?.data?.profilePhoto != Strings.NO_PROFILE_PIC) {
                                if(reloadViews){
                                    AsyncImage(
                                        url: URL(string: profileVM.profileModel?.data?.profilePhoto ?? "")!,
                                        placeholder: {
                                            if let name = profileVM.profileModel?.data?.firstName , let lastName =  profileVM.profileModel?.data?.firstName {
                                                HStack {
                                                    Text(String(name.prefix(1)))
                                                    Text(String(lastName.prefix(1)))
                                                }
                                            }
                                           else if let name = profileVM.profileModel?.data?.firstName {
                                                Text(String(name.prefix(1)))
                                            } else {
                                                Text("Loading...").applyFontRegular(size: 10)
                                            }
                                        },
                                        image: { Image(uiImage: $0).resizable() }
                                    ).frame(width: 100, height: 80, alignment: .center)
                                } else {
                                    AsyncImage(
                                        url: URL(string: profileVM.profileModel?.data?.profilePhoto ?? "")!,
                                        placeholder: { Text("Loading ...").applyFontRegular(size: 12) },
                                        image: { Image(uiImage: $0).resizable() }
                                    ).frame(width: 100, height: 80, alignment: .center)
                                }
                            } else {
                                // TODO: Add the placeholder image here
                                Images.PRIVACY_ICON
                                    .resizable()
                                    .frame(width: 100, height: 80, alignment: .center)
                                    .foregroundColor(Color.BLUE)
                            }
                        }.cardify(borderColor: Color.GRAY_TEXT)
                            .onTapGesture { onProfilePicClick() }
                        VStack {
                            HStack(spacing: 0) {
                                if let fName = profileVM.profileModel?.data?.firstName , let lName = profileVM.profileModel?.data?.lastName {
                                    let fullName  = "\(String(describing: fName)) \(String(describing: lName))"
                                    Text(fullName)
                                        .applyFontBold(size: 16)
                                }
                                if  profileVM.profileModel?.data?.isApproved == true {
                                    Images.GREEN_CHECK.padding(.leading,5)
                                }
                                Spacer()
                            }.padding(.top, 5)
                            
                            HStack {
                                if let role = profileVM.profileModel?.data?.role {
                                    Text(role)
                                        .applyFontBold(color:Color.TEXT_GREEN, size: 14)
                                }
                                Spacer()
                            }
                            HStack{
                                Images.LOCATION_PIN
                                    .frame(width: 15)
                                if let address = profileVM.profileModel?.data?.location?.formattedAddress {
                                    Text(address)
                                        .applyFontRegular(size: 13)
                                }
                                Spacer()
                            }
                        }.padding(.leading,5)
                    }
                }.padding(15)
            }.onAppear{
                reloadViews.toggle()
            }
        }
    }
    
    struct SettingsView: View {
        @StateObject var profileVM: ProfileViewModel
        @State private var showProfileSettings = false
        @State private var showNotificationSettings = false
        @State private var showSecuritySettings = false
        var body: some View {
            ZStack {
                VStack(alignment: .leading) {
                    ProfileRowView(title: Strings.PROFILE_SETTINGS, leadingImage: Images.PROFILE_ICON, trailingimage: Images.DISCLOSURE){
                        showProfileSettings = true
                    }
                    ProfileRowView(title: Strings.NOTIFICATIONS, leadingImage: Images.NOTIFICATION_ICON, trailingimage: Images.DISCLOSURE){
                        showNotificationSettings = true
                    }
                    ProfileRowView(title: Strings.SECURITY, leadingImage: Images.SECURITY_ICON, trailingimage: Images.DISCLOSURE){
                        showSecuritySettings = true
                    }
                }
                .navigationDestination(isPresented: $showProfileSettings) {
                    ProfileSettingsView(profileVM: profileVM)
                }
                .navigationDestination(isPresented: $showNotificationSettings) {
                    NotificationSettingsView(profileVM: profileVM)
                }
                .navigationDestination(isPresented: $showSecuritySettings) {
                    SecuritySettingsView(profileVM: profileVM)
                }
            }
            .background(Color.SCREEN_BG)
        }
    }
    struct LegalsView: View {
        @State private var pushNotificationOn = true
        @State private var marketingNotificationOn = true
        var body: some View {
            ZStack {
                VStack(alignment: .leading) {
                    ProfileRowView(title: Strings.PRIVACY_STATEMENT, leadingImage: Images.PRIVACY_ICON, trailingimage: Images.LEGAL_DISCLOSURE) {
                    }
                    ProfileRowView(title: Strings.T_AND_C, leadingImage: Images.TANDC_ICON, trailingimage: Images.LEGAL_DISCLOSURE){
                        
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
            } .padding(.horizontal,15)
                .padding(.vertical,18)
                .cardify()
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
                    .frame(width: 45, height: 25)
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
        ProfileView(profileVM: ProfileViewModel())
    }
}
