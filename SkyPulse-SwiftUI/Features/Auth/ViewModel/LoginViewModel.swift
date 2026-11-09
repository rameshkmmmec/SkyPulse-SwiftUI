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
    case pwd
    case otp
    case invalid
}

final class LoginViewModel: ObservableObject {
    
    @Published var emailOrMobile: String = ""
    @Published var passOrOtp: String = ""
    @Published var countryCode: CountryCode = CountryCode(name: "India", flag: "🇮🇳", dialCode: "+91")
    @Published var isEmailMode: Bool = false
    @Published var isPassOtpView: Bool = false
    @Published var mode: AuthSecondaryState = .password

    init(emailOrMobile: String) {
        self.emailOrMobile = emailOrMobile
    }

    // Auto-detect Input Type
    var inputType: InputType {
        let trimmed = (!isPassOtpView ? emailOrMobile : passOrOtp).trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return .empty }
        if LoginValidator.isValidEmail(trimmed) { return .email }
        if LoginValidator.isValidMobile(trimmed) { return .mobile }
        if LoginValidator.isValidPassword(trimmed) { return .pwd }
        if LoginValidator.isValidOtp(trimmed) { return .otp }
        return .invalid
    }
    
    // Validation Flags
    var isContineuEnabled: Bool {
        inputType == .email || inputType == .mobile
    }
    
    var isSubmitBtnEnabled: Bool {
        inputType == .pwd || inputType == .otp
    }
    
    var inputErrorMessage: String? {
        switch inputType {
        case .empty:
            return "Please enter email or mobile number"
        case .invalid:
            return "Enter a valid email or phone number with country code"
        case .email, .mobile:
            return nil
        case .pwd, .otp:
            return nil
        }
    }

}
//We are facing some technical difficulties at the moment. Please try again.
