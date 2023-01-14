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

    
}
