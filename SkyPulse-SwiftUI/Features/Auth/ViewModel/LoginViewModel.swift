//
//  LoginViewModel.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 08/11/26.
//

import Foundation
import Combine

enum InputType {
    case empty
    case email
    case mobile
    case invalid
}

final class LoginViewModel: ObservableObject {
    
    @Published var emailOrMobile: String = ""
    @Published var countryCode: CountryCode = CountryCode(name: "India", flag: "🇮🇳", dialCode: "+91")

    init(emailOrMobile: String) {
        self.emailOrMobile = emailOrMobile
    }

    // Auto-detect Input Type
    var inputType: InputType {
        let trimmed = emailOrMobile.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return .empty }
        if LoginValidator.isValidEmail(trimmed) { return .email }
        if LoginValidator.isValidMobile(trimmed) { return .mobile }
        return .invalid
    }
    
    // Validation Flags
    var isContinieEnabled: Bool {
        inputType == .email || inputType == .mobile
    }
    
    var inputErrorMessage: String? {
        switch inputType {
        case .empty:
            return "Please enter email or mobile number"
        case .invalid:
            return "Enter a valid email or phone number with country code"
        case .email, .mobile:
            return nil
        }
    }

}
//We are facing some technical difficulties at the moment. Please try again.
