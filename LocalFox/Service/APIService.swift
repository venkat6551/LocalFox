//
//  APIService.swift
//  LocalFox
//
//  Created by venkatesh karra on 03/02/23.
//

import Foundation
import CoreLocation
import Alamofire


protocol APIServiceProtocol {
    
    func login(credentials: LoginCredentialsModel, completion: @escaping (_ success: Bool, _ errorString : String?) -> Void)
    func resetPassword(email: String, completion: @escaping (_ success: Bool, _ errorString : String?) -> Void)
    func sendMobileCode (sigmUpModel: SignupModel, completion: @escaping (_ success: Bool, _ errorString: String?) -> Void)
    func validateMobileCode(sigmUpModel: SignupModel,verificateCode: String, completion: @escaping (_ success: Bool, _ referenceNumber: String? ,_ errorString: String?) -> Void)
    func sendEmailCode(sigmUpModel: SignupModel, completion: @escaping (_ success: Bool, _ errorString: String?) -> Void)
    func validateEmailCode(sigmUpModel: SignupModel,verificateCode: String, context: String, completion: @escaping (_ success: Bool, _ referenceNumber: String? ,_ errorString: String?) -> Void)
    func registerPartner(sigmUpModel: SignupModel,password: String, completion: @escaping (_ success: Bool,_ errorString: String?) -> Void)
    func getProfile(completion: @escaping (_ success: Bool, _ profileModel : ProfileModel?, _ errorString: String?) -> Void)
}

final class MockAPIService: APIServiceProtocol {
    
    func login(credentials: LoginCredentialsModel, completion: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let parameters: Parameters = [
            "password": credentials.password.trimmingCharacters(in: .whitespaces),
            "emailAddress": credentials.email.trimmingCharacters(in: .whitespaces)
        ]
        let request = AF.request(
            APIEndpoints.AUTHENTICATE_USER,
            method: HTTPMethod.post,
            parameters: parameters,
            encoding:JSONEncoding.default
        )
        request
            .validate(statusCode: 200..<300)
            .responseDecodable(of: LoginResponseDecodable.self) { response in
                switch response.result {
                case .success(let data):
                    if let token = data.token { // Success
                        MyUserDefaults.userToken = token
                        completion(true, nil)
                    } else {
                        completion(false,"Please try again later.")
                    }
                case .failure(let err):
                    guard let data = response.data else {
                        completion(false,err.localizedDescription)
                        return
                    }
                    do{
                        let errorObj = try JSONDecoder().decode(ErrorResponseDecodable.self, from: data)
                        completion(false,errorObj.error)
                    } catch{
                        completion(false,error.localizedDescription)
                    }
                }
            }
    }
    
    func resetPassword(email: String, completion: @escaping (_ success: Bool, _ errorString : String?) -> Void) {
        let parameters: Parameters = [
            "emailAddress": email.trimmingCharacters(in: .whitespaces).lowercased()
        ]
        let request = AF.request(
            APIEndpoints.RESET_PASSWORD,
            method: HTTPMethod.post,
            parameters: parameters,
            encoding:JSONEncoding.default
        )
        request
            .validate(statusCode: 200..<300)
            .responseDecodable(of: LoginResponseDecodable.self) { response in
                debugPrint(response)
                switch response.result {
                case .success(_):
                    completion(true, "")
                case .failure(let err):
                    guard let data = response.data else {
                        completion(false,err.localizedDescription)
                        return
                    }
                    do{
                        let errorObj = try JSONDecoder().decode(ErrorResponseDecodable.self, from: data)
                        completion(false,errorObj.error)
                    } catch{
                        completion(false,error.localizedDescription)
                    }
                }
            }
    }
    
    func sendMobileCode(sigmUpModel: SignupModel, completion: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let parameters: Parameters = [
            "firstName": sigmUpModel.firstName.trimmingCharacters(in: .whitespaces),
            "mobileNumber": sigmUpModel.formattedMobileNumber.trimmingCharacters(in: .whitespaces)
        ]
        let request = AF.request(
            APIEndpoints.SEND_MOBILE_CODE,
            method: HTTPMethod.post,
            parameters: parameters,
            encoding:JSONEncoding.default
        )
        request
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SuccessResponseDecodable.self) { response in
                switch response.result {
                case .success(let data):
                    completion(true, data.data)
                case .failure(let err):
                    guard let data = response.data else {
                        completion(false,err.localizedDescription)
                        return
                    }
                    do{
                        let errorObj = try JSONDecoder().decode(ErrorResponseDecodable.self, from: data)
                        completion(false,errorObj.error)
                    } catch{
                        completion(false,error.localizedDescription)
                    }
                }
            }
    }
    
    func validateMobileCode(sigmUpModel: SignupModel,verificateCode: String, completion: @escaping (_ success: Bool, _ referenceNumber: String? ,_ errorString: String?) -> Void) {
        let parameters: Parameters = [
            "verificationCode": verificateCode.trimmingCharacters(in: .whitespaces),
            "verificationType": "MOBILE",
            "context": "VERIFY_MOBILE",
            "mobileNumber": sigmUpModel.formattedMobileNumber.trimmingCharacters(in: .whitespaces)
        ]
        let request = AF.request(
            APIEndpoints.VALIDATEMOBILE_CODE,
            method: HTTPMethod.post,
            parameters: parameters,
            encoding:JSONEncoding.default
        )
        request
            .validate(statusCode: 200..<300)
            .responseDecodable(of: validateMobileCodeDecodable.self) { response in
                switch response.result {
                case .success(let data):
                    completion(true,data.mobileVerificationReference, data.data)
                case .failure(let err):
                    guard let data = response.data else {
                        completion(false,nil,err.localizedDescription)
                        return
                    }
                    do{
                        let errorObj = try JSONDecoder().decode(ErrorResponseDecodable.self, from: data)
                        completion(false,nil,errorObj.error)
                    } catch{
                        completion(false,nil,error.localizedDescription)
                    }
                }
            }
    }
    
    func sendEmailCode(sigmUpModel: SignupModel, completion: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let parameters: Parameters = [
            "firstName": sigmUpModel.firstName.trimmingCharacters(in: .whitespaces),
            "emailAddress": sigmUpModel.email.trimmingCharacters(in: .whitespaces).lowercased()
        ]
        let request = AF.request(
            APIEndpoints.SEND_EMAIL_CODE,
            method: HTTPMethod.post,
            parameters: parameters,
            encoding:JSONEncoding.default
        )
        request
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SuccessResponseDecodable.self) { response in
                switch response.result {
                case .success(let data):
                    completion(true, data.data)
                case .failure(let err):
                    guard let data = response.data else {
                        completion(false,err.localizedDescription)
                        return
                    }
                    do{
                        let errorObj = try JSONDecoder().decode(ErrorResponseDecodable.self, from: data)
                        completion(false,errorObj.error)
                    } catch{
                        completion(false,error.localizedDescription)
                    }
                }
            }
    }
    
    func validateEmailCode(sigmUpModel: SignupModel,verificateCode: String, context: String, completion: @escaping (_ success: Bool, _ referenceNumber: String? ,_ errorString: String?) -> Void) {
        let parameters: Parameters = [
            "verificationCode": verificateCode.trimmingCharacters(in: .whitespaces),
            "verificationType": "EMAIL",
            "context": context,
            "emailAddress": sigmUpModel.email.trimmingCharacters(in: .whitespaces).lowercased()
        ]
        
        
        let urlString = (context == "VERIFY_EMAIL") ? APIEndpoints.VALIDATE_EMAIL_CODE : APIEndpoints.VALIDATE_RESET_PASSWORD_CODE
        let request = AF.request(
            urlString,
            method: HTTPMethod.post,
            parameters: parameters,
            encoding:JSONEncoding.default
        )
        request
            .validate(statusCode: 200..<300)
            .responseDecodable(of: validateEmailCodeDecodable.self) { response in
                switch response.result {
                case .success(let data):
                    completion(true,data.emailVerificationReference, data.data)
                case .failure(let err):
                    guard let data = response.data else {
                        completion(false,nil,err.localizedDescription)
                        return
                    }
                    do{
                        let errorObj = try JSONDecoder().decode(ErrorResponseDecodable.self, from: data)
                        completion(false,nil,errorObj.error)
                    } catch{
                        completion(false,nil,error.localizedDescription)
                    }
                }
            }
    }
    
    func registerPartner(sigmUpModel: SignupModel,password: String, completion: @escaping (_ success: Bool,_ errorString: String?) -> Void) {
        let parameters: Parameters = [
            "firstName" :sigmUpModel.firstName.trimmingCharacters(in: .whitespaces),
            "lastName":sigmUpModel.lastName.trimmingCharacters(in: .whitespaces),
            "mobileNumber": sigmUpModel.formattedMobileNumber.trimmingCharacters(in: .whitespaces),
            "emailAddress":sigmUpModel.email.trimmingCharacters(in: .whitespaces).lowercased(),
            "password":password,
            "mobileVerificationReference":sigmUpModel.mobileVerificationReference!,
            "emailVerificationReference":sigmUpModel.emailVerificationReference!
        ]
        let request = AF.request(
            APIEndpoints.REGISTRATION_PARTNER,
            method: HTTPMethod.post,
            parameters: parameters,
            encoding:JSONEncoding.default
        )
        request
            .validate(statusCode: 200..<300)
            .responseDecodable(of: RegisterResponseDecodable.self) { response in
                switch response.result {
                case .success(let data):
                    completion(true,data.token)
                case .failure(let err):
                    guard let data = response.data else {
                        completion(false,err.localizedDescription)
                        return
                    }
                    do{
                        let errorObj = try JSONDecoder().decode(ErrorResponseDecodable.self, from: data)
                        completion(false,errorObj.error)
                    } catch{
                        completion(false,error.localizedDescription)
                    }
                }
            }
    }
    
    func getProfile(completion: @escaping (_ success: Bool, _ profileModel : ProfileModel?, _ errorString: String?) -> Void) {
        let headers: HTTPHeaders = [.authorization(bearerToken: MyUserDefaults.userToken!)]
        let request = AF.request(
            APIEndpoints.GET_PROFILE,
            method: HTTPMethod.get,
            encoding:JSONEncoding.default,
            headers: headers
        )
        request
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ProfileModel.self) { response in
                switch response.result {
                case .success(let data):
                    let model = ProfileModel(success: data.success, data:  data.data)
                    print(model)
                    completion(true,model,"")
                case .failure(let err):
                    guard let data = response.data else {
                        completion(false,nil,err.localizedDescription)
                        return
                    }
                    do{
                        let errorObj = try JSONDecoder().decode(ErrorResponseDecodable.self, from: data)
                        completion(false,nil,errorObj.error)
                    } catch{
                        completion(false,nil,error.localizedDescription)
                    }
                }
            }
    }
}
