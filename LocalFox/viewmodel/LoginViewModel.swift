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
    @Published var error: AuthenticationStatus.AuthenticationError?
    @Published var authenticationSuccess: Bool = false
    @Published var authenticationFailed: Bool = false
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = MockAPIService()) {
        self.apiService = apiService
    }
    
    func login(completion: @escaping (Bool) -> Void) {
        guard credentials.isValid else {
            return completion(false)
            
        }
        authenticationSuccess = false
        authenticationFailed = false
        print("authenticationFailed false")
        error = nil
        isLoading = true
        apiService.login(credentials: credentials) { [weak self] (result: Result<Bool, AuthenticationStatus.AuthenticationError>) in
            switch result {
            case .success:
                // authenticate user right after login is success
                MyUserDefaults.userEmail = self?.credentials.email
                self?.error = nil
                self?.authenticationSuccess = true
                completion(true)
            case .failure(let authError):
                completion(false)
                self?.error = authError
                self?.authenticationFailed = true
                print("authenticationFailed")
            }
            self?.isLoading = false
        }
    }
}
