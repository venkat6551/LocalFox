//
//  APIService.swift
//  LocalFox
//
//  Created by venkatesh karra on 03/02/23.
//

import Foundation
import CoreLocation
import Alamofire
import UIKit

typealias CompletionHandler = (_ success: Bool, _ photoUrl : String, _ errorString : String?) -> Void

protocol APIServiceProtocol {
    
    func login(credentials: LoginCredentialsModel, completion: @escaping (_ success: Bool, _ errorString : String?) -> Void)
    func resetPassword(email: String, completion: @escaping (_ success: Bool, _ errorString : String?) -> Void)
    func sendMobileCode (sigmUpModel: SignupModel, completion: @escaping (_ success: Bool, _ errorString: String?) -> Void)
    func validateMobileCode(sigmUpModel: SignupModel,verificateCode: String, completion: @escaping (_ success: Bool, _ referenceNumber: String? ,_ errorString: String?) -> Void)
    func sendEmailCode(sigmUpModel: SignupModel, completion: @escaping (_ success: Bool, _ errorString: String?) -> Void)
    func validateEmailCode(sigmUpModel: SignupModel,verificateCode: String, context: String, completion: @escaping (_ success: Bool, _ referenceNumber: String? ,_ errorString: String?) -> Void)
    func registerPartner(sigmUpModel: SignupModel,password: String, completion: @escaping (_ success: Bool,_ errorString: String?) -> Void)
    func getProfile(completion: @escaping (_ success: Bool, _ profileModel : ProfileModel?, _ errorString: String?) -> Void)
    func setNewPassword(password:String, model: SignupModel, completion: @escaping (_ success: Bool, _ errorString : String?) -> Void)
    func updateMobileNumber(mobileNumber:String, referanceNumber:String, completion: @escaping (_ success: Bool, _ errorString : String?) -> Void)
    func updateNotificationSettings(pushNotifications:Bool, smsNotifications:Bool, emailNotifications:Bool, announcements:Bool, events:Bool, completion: @escaping (_ success: Bool, _ errorString : String?) -> Void)
    func uploadImage(_withPhoto photo:Data, completionHandler:  @escaping CompletionHandler) -> Void
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
    
    func setNewPassword(password:String, model: SignupModel, completion: @escaping (_ success: Bool, _ errorString : String?) -> Void) {
        let parameters: Parameters = [
            "emailAddress" : model.email.trimmingCharacters(in: .whitespaces).lowercased(),
            "newPassword" : password,
            "referenceId" : model.emailVerificationReference!
        ]
        let request = AF.request(
            APIEndpoints.SET_NEW_PASSWORD,
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
    
    func updateMobileNumber(mobileNumber:String, referanceNumber:String, completion: @escaping (_ success: Bool, _ errorString : String?) -> Void) {
        let headers: HTTPHeaders = [.authorization(bearerToken: MyUserDefaults.userToken!)]
        let parameters: Parameters = [
            "mobileNumber" :mobileNumber.trimmingCharacters(in: .whitespaces),
            "mobileVerificationReference":referanceNumber,
        ]
        let request = AF.request(
            APIEndpoints.UPDATE_MOBILE_NUMBER,
            method: HTTPMethod.put,
            parameters: parameters,
            encoding:JSONEncoding.default,
            headers: headers
        )
        request
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SuccessResponseDecodable.self) { response in
                switch response.result {
                case .success(let data):
                    completion(true,data.data)
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
    
    func updateNotificationSettings(pushNotifications:Bool, smsNotifications:Bool, emailNotifications:Bool, announcements:Bool, events:Bool, completion: @escaping (_ success: Bool, _ errorString : String?) -> Void) {
        
        let headers: HTTPHeaders = [.authorization(bearerToken: MyUserDefaults.userToken!)]
        let parameters: Parameters = [
            "pushNotifications": pushNotifications,
            "smsNotifications": smsNotifications,
            "emailNotifications": emailNotifications,
            "announcements": announcements,
            "events": events
        ]
        let request = AF.request(
            APIEndpoints.UPDATE_NOTIFICATION_SETTINGS,
            method: HTTPMethod.put,
            parameters: parameters,
            encoding:JSONEncoding.default,
            headers: headers
        )
        request
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SuccessResponseDecodable.self) { response in
                switch response.result {
                case .success(let data):
                    completion(true,data.data)
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
    
    func getHeadersWithToken() -> [String : String]? {
        let requestHeaders:[String : String] = ["Content-Type":"multipart/form-data",
                                                "Accept":"application/json",
                                                "Authorization":String (format: "Bearer %@", MyUserDefaults.userToken!)]
        return requestHeaders
    }
    
    
    func uploadImage(_withPhoto photo:Data, completionHandler:  @escaping CompletionHandler) -> Void {
        
        let filename = "image.png"
        
        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString
        
        let fieldName = "reqtype"
        let fieldValue = "fileupload"
        
        let fieldName2 = "userhash"
        let fieldValue2 = "caa3dce4fcb36cfdf9258ad9c"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string:  APIEndpoints.UPLOAD_PROFILE_PHOTO)
        guard let requestUrl = url else { fatalError() }
        
        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = getHeadersWithToken()
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        // Add the reqtype field and its value to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue)".data(using: .utf8)!)
        
        // Add the userhash field and its value to the raw http reqyest data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName2)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue2)".data(using: .utf8)!)
        
        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(photo)
        
        // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        // According to the HTTP 1.1 specification https://tools.ietf.org/html/rfc7230
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            guard let dataLocal = responseData, error == nil else {
                DispatchQueue.main.async {
                    completionHandler(false, "", error?.localizedDescription)
                }
                return
            }
            do{
                let responseObj = try JSONDecoder().decode(SuccessResponseDecodable.self, from: dataLocal)
                if responseObj.success {
                    completionHandler(true,responseObj.data, "")
                } else {
                    completionHandler(false,"",responseObj.data)
                }
            } catch{
                completionHandler(false,"",error.localizedDescription)
            }
        }).resume()
    }
    
}
