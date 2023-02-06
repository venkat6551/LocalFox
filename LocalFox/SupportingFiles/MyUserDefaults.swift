//
//  MyUserDefaults.swift
//  Hapag-Lloyd
//
//  Place to keep all UserDefaults
//
//  Created by Meet Vora on 2022-07-15.
//

import Foundation

enum MyUserDefaults {
    
    // Login
    private static let KEY_LOGGED_IN: String = "isLoggedIn"
    static var isLoggedIn: Bool = (UserDefaults.standard.bool(forKey: KEY_LOGGED_IN) == true) {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: KEY_LOGGED_IN)
            if !isLoggedIn { // Logging out
                // Reset userID and userToken
                userID = nil
                userToken = nil
            }
        }
    }
    
    private static let KEY_FIRST_LOGIN: String = "isLoggedInFirstTime"
    static var isLoggedInFirstTime = (UserDefaults.standard.bool(forKey: KEY_FIRST_LOGIN) == true) {
        didSet {
            UserDefaults.standard.set(isLoggedInFirstTime, forKey: KEY_FIRST_LOGIN)
        }
    }
    
    // User
    private static let KEY_USER_ID: String = "userID"
    static var userID: Int? = (UserDefaults.standard.integer(forKey: KEY_USER_ID) == 0 ? nil : UserDefaults.standard.integer(forKey: KEY_USER_ID)) {
        didSet {
            UserDefaults.standard.set(userID, forKey: KEY_USER_ID)
        }
    }
    
    private static let KEY_USER_TOKEN: String = "userToken"
    static var userToken: String? = (UserDefaults.standard.string(forKey: KEY_USER_TOKEN) == "" ? nil : UserDefaults.standard.string(forKey: KEY_USER_TOKEN)) {
        didSet {
            UserDefaults.standard.set(userToken, forKey: KEY_USER_TOKEN)
        }
    }
    
    private static let KEY_USER_EMAIL: String = "userEmail"
    static var userEmail: String? = (UserDefaults.standard.string(forKey: KEY_USER_EMAIL) == "" ? nil : UserDefaults.standard.string(forKey: KEY_USER_EMAIL)) {
        didSet {
            UserDefaults.standard.set(userEmail, forKey: KEY_USER_EMAIL)
        }
    }
    
     
    // Install Photo instructions
    private static let KEY_DONT_SHOW_CONTAINER_INSTRUCTION: String = "dontShowContainerInstruction"
    static var dontShowContainerInstruction = (UserDefaults.standard.bool(forKey: KEY_DONT_SHOW_CONTAINER_INSTRUCTION) == true) {
        didSet {
            UserDefaults.standard.set(dontShowContainerInstruction, forKey: KEY_DONT_SHOW_CONTAINER_INSTRUCTION)
        }
    }
    private static let KEY_DONT_SHOW_DEVICE_INSTRUCTION: String = "dontShowDeviceInstruction"
    static var dontShowDeviceInstruction = (UserDefaults.standard.bool(forKey: KEY_DONT_SHOW_DEVICE_INSTRUCTION) == true) {
        didSet {
            UserDefaults.standard.set(dontShowContainerInstruction, forKey: KEY_DONT_SHOW_DEVICE_INSTRUCTION)
        }
    }
    
    // pin and biometric
    private static let PIN_IS_SET: String = "UserPin"
    static var userPIN: String? = (UserDefaults.standard.string(forKey: PIN_IS_SET) == "" ? nil : UserDefaults.standard.string(forKey: PIN_IS_SET)) {
        didSet {
            UserDefaults.standard.set(userPIN, forKey: PIN_IS_SET)
        }
    }
    
    private static let USING_BIOMETRIC: String = "useBiometric"
    static var userBiometric = (UserDefaults.standard.bool(forKey: USING_BIOMETRIC) == true) {
        didSet {
            UserDefaults.standard.set(userBiometric, forKey: USING_BIOMETRIC)
        }
    }
}
