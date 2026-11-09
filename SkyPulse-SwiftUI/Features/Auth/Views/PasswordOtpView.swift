//
//  PasswordOtpView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 08/11/26.
//

import SwiftUI

enum AuthSecondaryState {
    case password
    case otp
}

struct PasswordOtpView: View {
    
    @StateObject private var vm: LoginViewModel
    let mode: AuthSecondaryState
    @Binding var password: String
    @Binding var otp: String
    
    var body: some View {
        
        Group {
            switch mode {
            case .password:
                AppPasswordField(text: $password)
            case .otp:
                OTPVerificationField(otpCode: $otp)
            }
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }
}


struct OTPVerificationField: View {
    @Binding var otpCode: String
    var maxDigits: Int = 6
    @FocusState private var isFocused: Bool
    
    private let activeColor = Color(hex: "#065AF3")
    private let defaultBorder = Color.gray.opacity(0.3)
    
    var body: some View {
        ZStack {
            // Hidden native text field for keyboard handling
            TextField("", text: $otpCode)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode) // Auto-fill OTP from SMS
                .focused($isFocused)
                .opacity(0.01)
                .onChange(of: otpCode) { _, newValue in
                    let digits = newValue.filter { $0.isNumber }
                    otpCode = String(digits.prefix(maxDigits))
                }
            
            // Visual Digit Boxes
            HStack(spacing: 10) {
                ForEach(0..<maxDigits, id: \.self) { index in
                    let digit = getDigit(at: index)
                    let isCurrentBox = isFocused && (index == otpCode.count || (index == maxDigits - 1 && otpCode.count == maxDigits))
                    
                    Text(digit)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .rectangleCard(
                            cornerRadius: 8,
                            fillColor: .white,
                            borderColor: isCurrentBox ? activeColor : defaultBorder,
                            lineWidth: isCurrentBox ? 1.5 : 1
                        )
                }
            }
        }
        .onAppear {
            isFocused = true
        }
    }
    
    private func getDigit(at index: Int) -> String {
        guard index < otpCode.count else { return "" }
        let stringIndex = otpCode.index(otpCode.startIndex, offsetBy: index)
        return String(otpCode[stringIndex])
    }
}


struct AppPasswordField: View {
    @Binding var text: String
    var placeholder: String = "ENTER PASSWORD"
    @State private var isVisible: Bool = false
    
    private let cornerRadius: CGFloat = 8
    private let boxHeight: CGFloat = 50
    private let borderColor = Color.gray.opacity(0.35)
    
    var body: some View {
        HStack(spacing: 12) {
            // Left lock icon
            Image(systemName: "lock.fill")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .frame(width: 20)
            
            // Secure / Plain Text Field
            Group {
                if isVisible {
                    TextField(placeholder, text: $text)
                } else {
                    SecureField(placeholder, text: $text)
                }
            }
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.black)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            
            // Eye Toggle
            Button {
                isVisible.toggle()
            } label: {
                Image(systemName: isVisible ? "eye.slash.fill" : "eye.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 14)
        .frame(height: boxHeight)
        .rectangleCard(cornerRadius: cornerRadius, fillColor: .white, borderColor: borderColor)
    }
}
