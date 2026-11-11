//
//  String+Extensions.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 05/11/26.
//

import Foundation
import UIKit


extension String {
        
    func toDate(format: String = "dd/MM/yyyy") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: self)
    }
    
    func toAnyDateFormat(from inputFormat: String, to outputFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        // 1. String to Date (Parse assuming standard/UTC)
        formatter.dateFormat = inputFormat
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let date = formatter.date(from: self) else { return self }
        
        // 2. Date to String (Format into user's local timezone)
        formatter.dateFormat = outputFormat
        formatter.timeZone = .current
        return formatter.string(from: date)
    }
    
//    func toAnyDateFormat(from fromFormat: String,to toFormat: String,locale: Locale = Locale(identifier: "en_US_POSIX")) -> String? {
//        
//        let inputFormatter = DateFormatter()
//        inputFormatter.dateFormat = fromFormat
//        inputFormatter.locale = locale
//        
//        guard let date = inputFormatter.date(from: self) else {
//            return nil
//        }
//        
//        let outputFormatter = DateFormatter()
//        outputFormatter.dateFormat = toFormat
//        outputFormatter.locale = locale
//        
//        return outputFormatter.string(from: date)
//    }
}

