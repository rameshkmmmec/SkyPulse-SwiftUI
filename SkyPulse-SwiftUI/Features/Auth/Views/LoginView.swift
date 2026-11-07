//
//  LoginView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 08/11/26.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var vm: LoginViewModel
    var onCountryTap: () -> Void = {}

    init() {
        _vm = StateObject(wrappedValue: LoginViewModel(emailOrMobile: ""))
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            // 1. header view
            Text("Login or SignUp")
                .fontWith(size: 16, weight: .regular, color: .black.opacity(0.70))
                .padding(.top, 16)
            
            // 2. textfields
            SmartAuthInputField(text: $vm.emailOrMobile, selectedCountry: $vm.countryCode) {
                
            }
            
            // 3. seperator view
            HStack(alignment: .center, spacing: 10) {
                Rectangle()
                    .fill(.gray.opacity(0.35))
                    .frame(height: 1)
                Text("or")
                    .fontWith(size: 16, weight: .regular, color: .black.opacity(0.70))
                Rectangle()
                    .fill(.gray.opacity(0.35))
                    .frame(height: 1)
            }
            .padding(.top, 16)
            
            
            // 4. social login view
            HStack(alignment: .center, spacing: 0){
                Spacer()
                HStack(alignment: .center, spacing: 20){
                    buttonWIthAction(icon: "google-logo") {
                        
                    }
                    buttonWIthAction(icon: "facebook") {
                        
                    }
                }
                Spacer()
            }
                
            // 5. continue button view
            Button {
                // Action
            } label: {
                Text("Continue")
                    .fontWith(size: 18, weight: .semibold, color: vm.isContinieEnabled ? .white : .black.opacity(0.3))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(
                                vm.isContinieEnabled
                                ? AnyShapeStyle(LinearGradient.skyPrimary())
                                : AnyShapeStyle(Color(hex: "#CBCBCB"))
                            )
                    )
            }
            .padding(.top, 20)
            
            // 6. Terms & condition view
            LegalTermsFooterView()
            
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func buttonWIthAction(icon: String, action: @escaping ()->Void)-> some View {
        
        Button {
            action()
        } label: {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
        }
    }
}


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
    var onCountryTap: () -> Void = {}
    
    // Default me mobile dikhana hai; sirf tab email banega jab alphabets ya '@' type hon
    private var isEmailMode: Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.contains("@") || trimmed.contains(where: { $0.isLetter })
    }
    
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


import SafariServices

// MARK: - In-App Safari Sheet Wrapper
struct SafariWebView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: url)
        safariVC.view.tintColor = UIColor(red: 6/255, green: 90/255, blue: 243/255, alpha: 1) // Aviation blue
        return safariVC
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

// MARK: - Terms & Links Component
struct LegalTermsFooterView: View {
    // Apne actual URLs yahan configure karein
    private let privacyPolicyURL = "https://www.skypulse.com/privacy-policy"
    private let userAgreementURL = "https://www.skypulse.com/user-agreement"
    private let termsConditionURL = "https://www.skypulse.com/terms-and-conditions"
    
    @State private var selectedURL: URL?
    @State private var showSafariSheet: Bool = false

    // LocalizedStringKey ke markdown me teeno ke direct URLs map hain
    private var markdownLegalText: LocalizedStringKey {
        "By proceeding, you agree to SkyPulse [Privacy Policy](\(privacyPolicyURL)), [User Agreement](\(userAgreementURL)) and [T&Cs](\(termsConditionURL))"
    }

    var body: some View {
        Text(markdownLegalText)
            .font(.system(size: 13, weight: .regular))
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .tint(Color(hex: "#065AF3")) // Aviation Royal Blue accent
            .environment(\.openURL, OpenURLAction { url in
                // Intercept karke app ke andar hi Safari Controller open karein
                selectedURL = url
                showSafariSheet = true
                return .handled // Bahar Safari app me switch hone se rokta hai
            })
            .sheet(isPresented: $showSafariSheet) {
                if let url = selectedURL {
                    SafariWebView(url: url)
                        .ignoresSafeArea()
                }
            }
    }
}
