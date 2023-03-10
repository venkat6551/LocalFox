//
//  Utils.swift
//  Hapag-Lloyd
//
//  Utility class to hold all Utility functions
//
//  Created by Meet Vora on 2022-07-13.
//

import Foundation
import UIKit
import SwiftUI
import CoreLocation
import MessageUI

// Opens App-specific settings page.
// This is useful when user Denied any permission we wanted and we can reirect user to Settings page.
func openAppSettings() {
    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
        return
    }
    if UIApplication.shared.canOpenURL(settingsUrl) {
        UIApplication.shared.open(settingsUrl, completionHandler: nil)
    }
}



extension String {
    
    // Checks if the string is valid email or not, returns boolean accordingly
    var isValidEmail: Bool {
        let name = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let domain = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let emailRegEx = name + "@" + domain + "[A-Za-z]{2,8}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: self)
    }
    
    func matchesRegex(_ regexPattern: String) -> Bool {
        return self.range(of: regexPattern, options: .regularExpression) != nil
    }
    
    func convertToDate(formate: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = formate
        return dateFormatter.date(from: self)
    }
}

// Checks if camera hardware available or not. [Note: This is NOT a permission check]
var isCameraAvailable: Bool {
    UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
}

// Checks if hardware home button is present on device or not.
// Some older iOS devices such as iPod Touch, iPhone SE has hardware buttons instead of in-screen home handle.
// This boolean is handy when UI designing and achieve same results on both kind of devices.
var hasPhysicalHomeButton: Bool {
    if #available(iOS 11.0, *), let keyWindow = UIApplication.shared.keyWindow, keyWindow.safeAreaInsets.bottom > 0 {
        return false
    }
    return true
}

// Boolean to detect and run some code ONLY in preview mode. Such as instead of camera, we can show solid color background for design purpose.
var isRunningOnXCodePreview: Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}

var isSimulator: Bool {
#if targetEnvironment(simulator)
    // your simulator code
    return true
#else
    // your real device code
    return false
#endif
}

enum DateFormates {
    
    static let TIME: String = "hh:mm a"
    static let DATE: String = "MMM d, y"
    static let DATE_TIME: String = "\(TIME) \(DATE)"
    //static let API_DATE_TIME: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    //static let API_DATE_TIME: String = "yyyy-MM-dd'T'HH:mm:ssZ"
    //static let API_DATE_TIME_RECENT_PAIRING: String = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    
    // TODO: Keep an eye on this format on API side, if this changes, the date will disappear on UI. Blame DBP people :D
    static let API_DATE_TIME: String = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS'Z'"
    
}

extension Date {
    
    // Gives date in specific formate, such as "01:00:00 AM June 15, 2022"
    var dateAndTimeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormates.DATE_TIME
        return dateFormatter.string(from: self)
    }
    
    // Returns smart time difference (compared to now time) in String, like.. x seconds ago, x minutes ago, etc...
    var timeAgoString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    // Gives date in specific formate, such as "June 15, 2022"
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormates.DATE
        return dateFormatter.string(from: self)
    }
    
    // Gives time in specific formate, such as "01:00:00 AM"
    var timeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormates.TIME
        return dateFormatter.string(from: self)
    }
    
}



// Reverse geocode - returns "city, country" from lat-long provided
func decodeLocation(_ location: CLLocationCoordinate2D?, onComplete: @escaping ((String) -> Void)) {
    guard let location = location else { return }
    let geocoder = CLGeocoder()
    let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
    geocoder.reverseGeocodeLocation(clLocation, completionHandler: { placemarks, _ in
        if let placemarks = placemarks, !placemarks.isEmpty {
            let placemark = placemarks[0]
            let locationCountry = placemark.country ?? ""
            let locationCity = placemark.locality
            let cityCountry = "\(locationCity == nil ? "" : "\(locationCity!), ")\(locationCountry)"
            onComplete(cityCountry)
        }
    })
}

// Check if app is in DEBUG mode or not
var isDebug: Bool {
#if DEBUG
    return true
#else
    return false
#endif
}




// Check if can send email
var canSendEmail: Bool {
    return MFMailComposeViewController.canSendMail()
}

// Returns current app version
let appVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""

// Returns current app build number
let buildNumber: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? ""
