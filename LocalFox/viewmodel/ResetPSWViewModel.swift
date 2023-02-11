//
//  ResetPSWViewModel.swift
//  LocalFox
//
//  Created by venkatesh karra on 06/02/23.
//

import Foundation
class ResetPSWViewModel: ObservableObject {
    
    @Published var credentials = LoginCredentialsModel()
    @Published private(set) var isLoading: Bool = false
    @Published var errorString: String?
    @Published var resetPasswordSuccess: Bool = false
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = MockAPIService()) {
        self.apiService = apiService
    }
    
    func resetPassword(emailID:String, completion: @escaping (Bool) -> Void) {
        guard emailID.isValidEmail else {
            self.errorString = "Please enter valid details"
            return completion(false)
        }
        resetPasswordSuccess = false
        errorString = nil
        isLoading = true
        apiService.resetPassword(email: emailID) { [weak self] success, errorString in
            self?.resetPasswordSuccess = success
            self?.errorString = errorString
            completion(success)
            self?.isLoading = false
        }
    }
}
