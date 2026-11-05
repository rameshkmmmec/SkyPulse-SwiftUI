//
//  Date+Extensions.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 01/11/26.
//

import Foundation
import UIKit


extension Date {
    
    func toString(format: String = "E MMM dd yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
 
}
