//
//  ProfileViewModel.swift
//  LocalFox
//
//  Created by venkatesh karra on 16/02/23.
//

import Foundation
class ProfileViewModel: ObservableObject {
    
    @Published var profileModel: ProfileModel?
    @Published private(set) var isLoading: Bool = false
    @Published var errorString: String?
    @Published var getProfileSuccess: Bool = false
    @Published var updateNotificationSettingsSuccess: Bool = false
    private let apiService: APIServiceProtocol
    
    
    init(apiService: APIServiceProtocol = MockAPIService()) {
        self.apiService = apiService
    }
    
    func getProfile() {
        getProfileSuccess = false
        errorString = nil
        isLoading = true
        apiService.getProfile { [weak self] success, profileModel, errorString in
            self?.getProfileSuccess = success
            self?.errorString = errorString
            self?.profileModel = profileModel
            self?.isLoading = false
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
}
