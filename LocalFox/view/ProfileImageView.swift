//
//  ProfileImageView.swift
//  LocalFox
//
//  Created by venkatesh karra on 28/02/23.
//

import SwiftUI

struct ProfileImageView: View {
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    @State private var photoSelectedFromCam = false
    @State private var showErrorSnackbar: Bool = false
    @State var imageSelected  = UIImage()
    @StateObject var profileVM: ProfileViewModel
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack {
            if (photoSelectedFromCam == true) {
               
                VStack {
                    Image(uiImage: imageSelected).resizable()
                    HStack {
                        Button(action: {
                            if(!profileVM.isLoading) {
                                profileVM.uploadProfilePhoto(_withPhoto: imageSelected)
                            }
                        }, label: {
                            Text("Choose").applyFontHeaderMedium()
                        })
                        Spacer()
                        Button(action: {
                            if(!profileVM.isLoading) {
                                photoSelectedFromCam = false
                            }
                        }, label: {
                            Text("Cancel").applyFontHeaderMedium()
                        })
                    }.padding(.horizontal, Dimens.SCREEN_HORIZONTAL_PADDING)
                }.padding(20)
                if(profileVM.isLoading) {
                    VStack {
                        Text("Uploading...").foregroundColor(Color.white)
                            .padding(.horizontal,35).padding(.top,15)
                        ActivityIndicator(isAnimating: .constant(true), style: .large).foregroundColor(Color.white).padding(.bottom,10)
                    }.background(Color.gray).cardify()
                }
            } else {
                VStack {
                    if let image = profileVM.profileModel?.data?.profilePhoto {
                        AsyncImage(
                            url: URL(string: image)!,
                            placeholder: { Text("Loading ...") },
                            image: {
                                Image(uiImage: $0).resizable() }
                        )
                    } else {
                        Text("Loading ...")
                    }
                }.padding(20)
            }
        }
        .onAppear{
            self.photoSelectedFromCam = false
        }
        .background(Color.SCREEN_BG.ignoresSafeArea())
        .setNavTitle("Profile Photo", showBackButton: true,  trailingView: AnyView(
            Group {
                if (self.photoSelectedFromCam == false) {
                    Button(action: {
                        self.shouldPresentActionScheet = true
                    }, label: {
                        Text("Edit").applyFontHeaderMedium()
                    })
                }
            }
        ),leadingSpace: 20)
        
        .sheet(isPresented: $shouldPresentImagePicker) {
            ImagePicker(selectedImage: $imageSelected, sourceType: self.shouldPresentCamera ? .camera : .photoLibrary,onPhotoSelected: {
                self.photoSelectedFromCam = true
            })
        }
        .confirmationDialog("", isPresented: $shouldPresentActionScheet, titleVisibility: .hidden) {
            Button("Delete Photo",role: .destructive) {
            }
            Button("Take Photo") {
                self.shouldPresentImagePicker = true
                self.shouldPresentCamera = true
            }
            Button("Choose Photo") {
                self.shouldPresentImagePicker = true
                self.shouldPresentCamera = false
            }
            Button("Cancel", role: .cancel) {
            }
        }
        .snackbar(
            show: $showErrorSnackbar,
            snackbarType: SnackBarType.error,
            title: "Error",
            message: profileVM.errorString,
            secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
            onSnackbarDismissed: {showErrorSnackbar = false },
            isAlignToBottom: true
        )
        .onChange(of: profileVM.isLoading) { isloading in
            if profileVM.uploadProfilePhotoSuccess == true {
                self.presentationMode.wrappedValue.dismiss()
            } else if(profileVM.uploadProfilePhotoSuccess == false && profileVM.errorString != nil) {
                showErrorSnackbar = true
            }
        }
    }
}


struct ImagePreview: View {
    @StateObject var profileVM: ProfileViewModel
    var imageSelected:UIImage
    @State private var showErrorSnackbar: Bool = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack {
            VStack {
                Image(uiImage: imageSelected).resizable()
                HStack {
                    Button(action: {
                        if(!profileVM.isLoading) {
                            profileVM.uploadProfilePhoto(_withPhoto: imageSelected)
                        }
                    }, label: {
                        Text("Choose").applyFontHeaderMedium()
                    })
                    Spacer()
                    Button(action: {
                        if(!profileVM.isLoading) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }, label: {
                        Text("Cancel").applyFontHeaderMedium()
                    })
                }.padding(.horizontal, Dimens.SCREEN_HORIZONTAL_PADDING)
            }.padding(20)
            if(profileVM.isLoading) {
                VStack {
                    Text("Uploading...").foregroundColor(Color.white)
                        .padding(.horizontal,35).padding(.top,15)
                    ActivityIndicator(isAnimating: .constant(true), style: .large).foregroundColor(Color.white).padding(.bottom,10)
                }.background(Color.gray).cardify()
            }
        }
        .background(Color.SCREEN_BG.ignoresSafeArea())
            .setNavTitle("Profile Photo", showBackButton: true,leadingSpace: 20)
            .snackbar(
                show: $showErrorSnackbar,
                snackbarType: SnackBarType.error,
                title: "Error",
                message: profileVM.errorString,
                secondsAfterAutoDismiss: SnackBarDismissDuration.normal,
                onSnackbarDismissed: {showErrorSnackbar = false },
                isAlignToBottom: true
            )
            .onChange(of: profileVM.isLoading) { isloading in
                if profileVM.uploadProfilePhotoSuccess == true {
                    self.presentationMode.wrappedValue.dismiss()
                } else if(profileVM.uploadProfilePhotoSuccess == false && profileVM.errorString != nil) {
                    showErrorSnackbar = true
                }
            }
    }
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageView(profileVM: ProfileViewModel())
    }
}
