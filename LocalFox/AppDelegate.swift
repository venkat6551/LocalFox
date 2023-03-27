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
        GoogleApi.shared.initialiseWithKey("AIzaSyCNm9ALFy869lnQMQ9h_Q0B9QuX2ymg49o")
        return true
    }
}
