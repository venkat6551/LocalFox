//
//  LoginViewModel.swift
//  Hapag-Lloyd
//
//  Created by Meet Vora on 2022-07-15.
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var credentials = LoginCredentialsModel()
    @Published private(set) var isLoading: Bool = false
    @Published var errorString: String?
    @Published var authenticationSuccess: Bool = false
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = MockAPIService()) {
        self.apiService = apiService
    }
    
    func login(completion: @escaping (Bool) -> Void) {
        guard credentials.isValid else {
            self.errorString = "Please enter valid details"
            return completion(false)
        }
        authenticationSuccess = false
        errorString = nil
        isLoading = true
        apiService.login(credentials: credentials) { [weak self] success, errorString in
            if success {
                MyUserDefaults.userEmail = self?.credentials.email
            }
            self?.authenticationSuccess = success
            self?.errorString = errorString
            completion(success)
            self?.isLoading = false
        }
    }
}
