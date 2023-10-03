//
//  ProfileViewModel.swift
//  LocalFox
//
//  Created by venkatesh karra on 16/02/23.
//

import SwiftUI
class ProfileViewModel: ObservableObject {
    
    @Published var profileModel: ProfileModel?
    @Published private(set) var isLoading: Bool = false
    @Published var errorString: String?
    @Published var getProfileSuccess: Bool = false
    @Published var updateNotificationSettingsSuccess: Bool = false
    @Published var editProfilePhotoSuccess: Bool = false
    @Published var editAddressSuccess: Bool = false
    private let apiService: APIServiceProtocol
    
    
    init(apiService: APIServiceProtocol = MockAPIService()) {
        self.apiService = apiService
    }
    
    func getProfile() {
        getProfileSuccess = false
        errorString = nil
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.apiService.getProfile { [weak self] success, profileModel, errorString in
                DispatchQueue.main.async {
                    self?.getProfileSuccess = success
                    self?.errorString = errorString
                    self?.profileModel = profileModel
                    self?.isLoading = false
                }
            }
        }
        
       
    }
    
    func updateNotificationSettings(pushNotifications:Bool, smsNotifications:Bool, emailNotifications:Bool, announcements:Bool, events:Bool) {
        updateNotificationSettingsSuccess = false
        errorString = nil
        isLoading = true
        apiService.updateNotificationSettings(pushNotifications: pushNotifications, smsNotifications: smsNotifications, emailNotifications: emailNotifications, announcements: announcements, events: events) { [weak self] success, errorString in
            self?.updateNotificationSettingsSuccess = success
            self?.errorString = errorString
            self?.isLoading = false
            if success {
                self?.profileModel?.data?.NotificationSettings = NotificationSettings(pushNotifications: pushNotifications, smsNotifications: smsNotifications, emailNotifications: emailNotifications, announcements: announcements, events: events)
            }
        }
    }
    
    func uploadProfilePhoto(_withPhoto photo:UIImage) {
        editProfilePhotoSuccess = false
        errorString = nil
        isLoading = true
        guard let imageData = photo.jpegData(compressionQuality: 0.5) else { return }
        apiService.uploadImage(_withPhoto: imageData) {[weak self]  success, photoUrl, errorString in
            DispatchQueue.main.async {
                self?.editProfilePhotoSuccess = success
                self?.errorString = errorString
                self?.isLoading = false
                if success {
                    self?.profileModel?.data?.profilePhoto = photoUrl
                }
            }
        }
    }
    
    func updateAddress(_withAddress address:String) {
        editAddressSuccess = false
        errorString = nil
        isLoading = true
        apiService.updateAddress(address: address) {[weak self]  success, errorString in
           
            DispatchQueue.main.async {
                self?.editAddressSuccess = success
                self?.errorString = errorString
                self?.isLoading = false
                if success {
                    self?.profileModel?.data?.location?.formattedAddress = address
                }
            }
        }
        
    }
    func deleteProfilePhoto() {
        editProfilePhotoSuccess = false
        errorString = nil
        isLoading = true
        apiService.deleteProfilePic {[weak self] success, errorString in
            self?.editProfilePhotoSuccess = success
            self?.errorString = errorString
            self?.isLoading = false
            if success {
                self?.profileModel?.data?.profilePhoto = Strings.NO_PROFILE_PIC
            }
        }
    }
    func logoutUser(completion: @escaping () -> Void) {
        apiService.logoutUser { _, _ in
            completion()
        }
    }
}
