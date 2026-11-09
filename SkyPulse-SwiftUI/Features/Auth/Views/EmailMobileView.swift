//
//  EmailMobileView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 08/11/26.
//

import SwiftUI

struct CountryCode: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let flag: String
    let dialCode: String
}

extension CountryCode {
    static let defaultList: [CountryCode] = [
        CountryCode(name: "India", flag: "🇮🇳", dialCode: "+91"),
        CountryCode(name: "United States", flag: "🇺🇸", dialCode: "+1"),
        CountryCode(name: "United Arab Emirates", flag: "🇦🇪", dialCode: "+971"),
        CountryCode(name: "United Kingdom", flag: "🇬🇧", dialCode: "+44"),
        CountryCode(name: "Singapore", flag: "🇸🇬", dialCode: "+65")
    ]
}


struct SmartAuthInputField: View {
    @Binding var text: String
    @Binding var selectedCountry: CountryCode
    @Binding var isEmailMode: Bool
    var onCountryTap: () -> Void = {}
    
    // UI Dimensions & Styling
    private let cornerRadius: CGFloat = 8
    private let boxHeight: CGFloat = 50
    private let borderColor = Color.gray.opacity(0.35)
    
    var body: some View {
        HStack(spacing: 10) {
            
            // MARK: - Dynamic Leading Box (Default: Country Code)
            Group {
                if !isEmailMode {
                    // Default State & Numeric Input: Flag + Dial Code + Chevron
                    Button(action: onCountryTap) {
                        HStack(spacing: 5) {
                            Text(selectedCountry.flag)
                                .font(.system(size: 19))
                            
                            Text(selectedCountry.dialCode)
                                .fontWith(size: 17, weight: .semibold, color: .black)
                            
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal, 10)
                        .frame(height: boxHeight)
                        .rectangleCard(cornerRadius: cornerRadius, fillColor: .white, borderColor: borderColor)
                    }
                    .buttonStyle(.plain)
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .opacity
                    ))
                } else {
                    // Email Mode: Switches only when characters/letters appear
                    ZStack {
                        Image(systemName: "envelope.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                    }
                    .frame(width: 50, height: boxHeight)
                    .rectangleCard(cornerRadius: cornerRadius, fillColor: .white, borderColor: borderColor)
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .opacity
                    ))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isEmailMode)
            
            // MARK: - Input Field
            HStack {
                TextField(isEmailMode ? "ENTER EMAIL ID" : "ENTER MOBILE NUMBER", text: $text)
                    .fontWith(size: 17, weight: .semibold, color: .black)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .keyboardType(isEmailMode ? .emailAddress : .numberPad)
                
                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray.opacity(0.5))
                    }
                }
            }
            .padding(.horizontal, 14)
            .frame(height: boxHeight)
            .rectangleCard(cornerRadius: cornerRadius, fillColor: .white, borderColor: borderColor)
        }
    }
}
