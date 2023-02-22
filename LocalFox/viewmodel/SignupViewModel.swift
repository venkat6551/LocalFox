//
//  SignupViewModel.swift
//  LocalFox
//
//  Created by venkatesh karra on 11/02/23.
//

import Foundation


class SignupViewModel: ObservableObject {
    
    @Published var signupModel = SignupModel()
    @Published private(set) var isLoading: Bool = false
    @Published var errorString: String?
    @Published var sendMobileCodeSuccess: Bool = false
    @Published var validateMobileCodeSuccess: Bool = false
    @Published var sendEmailCodeSuccess: Bool = false
    @Published var validateEmailCodeSuccess: Bool = false
    @Published var registerPartnerSuccess: Bool = false
    @Published var resetPasswordSuccess: Bool = false
    @Published var setNewPasswordSuccess: Bool = false
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = MockAPIService()) {
        self.apiService = apiService
    }
    
    func sendMobileCode(completion: @escaping (Bool) -> Void) {
        guard signupModel.isValidMobileNumber else {
            self.errorString = "Please enter valid details"
            return completion(false)
        }
        sendMobileCodeSuccess = false
        errorString = nil
        isLoading = true
        apiService.sendMobileCode(sigmUpModel: signupModel) { [weak self]success, errorString in
            self?.sendMobileCodeSuccess = success
            self?.errorString = errorString
            completion(success)
            self?.isLoading = false
        }
    }
    
    func validateMobileCode(verificationCode:String, completion: @escaping (Bool) -> Void) {
        guard !verificationCode.isEmpty else {
            self.errorString = "Please enter verification Code"
            return completion(false)
        }
        validateMobileCodeSuccess = false
        errorString = nil
        isLoading = true
        
        apiService.validateMobileCode(sigmUpModel: signupModel, verificateCode: verificationCode) { [weak self] success, referenceNumber, errorString in
            self?.signupModel.mobileVerificationReference = referenceNumber
            self?.validateMobileCodeSuccess = success
            self?.errorString = errorString
            completion(success)
            self?.isLoading = false
        }
    }
    
    func sendEmailCode(completion: @escaping (Bool) -> Void) {
        guard signupModel.isValidEmail else {
            self.errorString = "Please enter valid details"
            return completion(false)
        }
        sendMobileCodeSuccess = false
        errorString = nil
        isLoading = true
        apiService.sendEmailCode(sigmUpModel: signupModel) { [weak self]success, errorString in
            self?.sendEmailCodeSuccess = success
            self?.errorString = errorString
            completion(success)
            self?.isLoading = false
        }
    }
    
    func validateEmailCode(verificationCode:String, context:String, completion: @escaping (Bool) -> Void) {
        guard !verificationCode.isEmpty else {
            self.errorString = "Please enter verification Code"
            return completion(false)
        }
        validateMobileCodeSuccess = false
        errorString = nil
        isLoading = true
        apiService.validateEmailCode(sigmUpModel: signupModel, verificateCode: verificationCode, context: context) { [weak self] success, referenceNumber, errorString in
            self?.signupModel.emailVerificationReference = referenceNumber
            self?.validateEmailCodeSuccess = success
            self?.errorString = errorString
            completion(success)
            self?.isLoading = false
        }
    }
    
    func registerPArtner(password:String, confirmPassword:String,completion: @escaping (Bool) -> Void) {
        guard !password.isEmpty else {
            self.errorString = "Please enter valid data"
            return completion(false)
        }
        guard password == confirmPassword else {
            self.errorString = "New Password and Confirm password not matching"
            return completion(false)
        }
        registerPartnerSuccess = false
        errorString = nil
        isLoading = true
        apiService.registerPartner(sigmUpModel: signupModel, password: password) { [weak self] success, errorString in
            self?.registerPartnerSuccess = success
            self?.errorString = errorString
            completion(success)
            self?.isLoading = false
        }
    }
    
    func resetPassword(emailID:String,completion: @escaping (Bool) -> Void) {
        guard !emailID.isEmpty && emailID.isValidEmail else {
            self.errorString = "Please enter valid data"
            return completion(false)
        }

        registerPartnerSuccess = false
        errorString = nil
        isLoading = true
        
        apiService.resetPassword(email: emailID) {[weak self] success, errorString in
            self?.resetPasswordSuccess = success
            self?.errorString = errorString
            completion(success)
            self?.isLoading = false
        }
    }
    
    
    func setNewPassword(password:String, confirmPassword:String, model:SignupModel, completion: @escaping (Bool) -> Void) {
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
    
    func clearData() {
        self.sendMobileCodeSuccess = false
        self.validateMobileCodeSuccess = false
        self.sendEmailCodeSuccess = false
        self.validateEmailCodeSuccess = false
        self.registerPartnerSuccess = false
        self.resetPasswordSuccess = false
        self.setNewPasswordSuccess = false
    }
}
    
