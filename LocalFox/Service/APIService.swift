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
            "emailAddress": email.trimmingCharacters(in: .whitespaces)
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
                    completion(true, nil)
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
}
