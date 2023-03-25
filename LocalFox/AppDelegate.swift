//
//  AppDelegate.swift
//  LocalFox
//
//  Created by venkatesh karra on 14/03/23.
//

import Foundation
import UIKit
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GoogleApi.shared.initialiseWithKey("AIzaSyDzSc35om6OoYp-B9PJ8_fijA4O4NaHMTM")
        return true
    }
}
