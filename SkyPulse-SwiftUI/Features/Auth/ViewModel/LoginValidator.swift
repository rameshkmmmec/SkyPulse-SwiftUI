//
//  LoginValidator.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 08/11/26.
//

import Foundation

struct LoginValidator {
    
    // MARK: - Email Validation
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}$"#
        return email.range(of: emailRegex, options: .regularExpression) != nil
    }
    
    // MARK: - International Mobile Validation (E.164)
    static func isValidMobile(_ phone: String) -> Bool {
        let cleanDigits = phone.filter { $0.isNumber }
        guard cleanDigits.count >= 7 && cleanDigits.count <= 15 else { return false }
        
        let e164Regex = #"^\+?[1-9]\d{6,14}$"#
        let sanitized = phone.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
        return sanitized.range(of: e164Regex, options: .regularExpression) != nil
    }
    
    // MARK: - Password Validation
    // Min 8 chars, at least 1 digit, at least 1 alphabet
    static func isValidPassword(_ pass: String) -> Bool {
        return pass.count >= 6
    }
}
