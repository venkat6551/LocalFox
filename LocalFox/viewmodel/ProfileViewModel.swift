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
    
    func setNewPassword(password:String, confirmPassword:String,completion: @escaping (Bool) -> Void) {
        guard !password.isEmpty else {
            self.errorString = "Please enter valid data"
            return completion(false)
        }
        guard password == confirmPassword else {
            self.errorString = "New Password and Confirm password not matching"
            return completion(false)
        }
        
        setNewPasswordSuccess = false
        errorString = nil
        isLoading = true
        
        apiService.setNewPassword(password: password, model: signupModel, completion: { [weak self] success, errorString in
            self?.setNewPasswordSuccess = success
            self?.errorString = errorString
            completion(success)
            self?.isLoading = false
        })
    }
    

}
