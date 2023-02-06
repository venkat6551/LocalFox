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
    
    func login(credentials: LoginCredentialsModel, completion: @escaping (Result<Bool, AuthenticationStatus.AuthenticationError>) -> Void)
    
}

final class MockAPIService: APIServiceProtocol {
    
    func login(credentials: LoginCredentialsModel, completion: @escaping (Result<Bool, AuthenticationStatus.AuthenticationError>) -> Void) {
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
               // debugPrint(response) // Prints API request and response in a nice readable formate
                switch response.result {
                case .success(let data):
                    if let token = data.token { // Success
                        MyUserDefaults.userToken = token
                        completion(Result.success(true))
                    } else {
                        completion(Result.failure(AuthenticationStatus.AuthenticationError.invalidCredentials))
                    }
                case .failure(let error):
                   // print("ERROR: \(error)")
                    completion(Result.failure(AuthenticationStatus.AuthenticationError.invalidCredentials))
                }
            }
    }
}
