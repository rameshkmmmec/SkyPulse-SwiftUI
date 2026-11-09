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
    @Environment(AuthManager.self) private var auth
    
    var onLoginSuccess: (() -> Void)
    
    init(onSuccess: @escaping () -> Void) {
        _vm = StateObject(wrappedValue: LoginViewModel(emailOrMobile: ""))
        onLoginSuccess = onSuccess
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if vm.isPassOtpView {
                passwordOrOtpView
            } else{
                emailorMobileView
            }
        }
        .padding(.horizontal, 16)
    }
    
    //MARK: Email or Mobile View
    @ViewBuilder
    private var emailorMobileView: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            // 1. header view
            Text("Login or SignUp")
                .fontWith(size: 16, weight: .regular, color: .black.opacity(0.70))
                .padding(.top, 16)
            
            // 2. textfields
            SmartAuthInputField(text: $vm.emailOrMobile, selectedCountry: $vm.countryCode, isEmailMode: $vm.isEmailMode) {
                
            }
            
            switchEmailorMobileLoginOption
            
            // 3. seperator view
            showHorizontaDivider
            
            // 4. social login view
            showSocialLogin
                
            // 5. continue button view
            showButtonType(title: "Continue", isEnabled: vm.isContineuEnabled) {
                vm.isPassOtpView = !(vm.isPassOtpView)
            }
            
            // 6. Terms & condition view
            LegalTermsFooterView()
            
        }
    }
    
    @ViewBuilder
    private var showSocialLogin: some View {
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
    
    @ViewBuilder
    private var showHorizontaDivider: some View {
        
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
    }
    
    @ViewBuilder
    private var switchEmailorMobileLoginOption: some View {
        
        HStack(){
            Spacer()
            Button {
                vm.isEmailMode = !vm.isEmailMode
            } label: {
                Text("Login or SignUp with \(vm.isEmailMode ? "Mobile":"Email")")
                    .fontPoppins(size: 15, weight: .medium, color: .blue)
            }
        }
    }

    @ViewBuilder
    private func showButtonType(title: String, isEnabled:Bool, action: @escaping ()->Void) -> some View {
        Button {
            action()
        } label: {
            Text(title)
                .fontWith(size: 18, weight: .semibold, color: isEnabled ? .white : .black.opacity(0.3))
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(
                            isEnabled
                            ? AnyShapeStyle(LinearGradient.skyPrimary())
                            : AnyShapeStyle(Color(hex: "#CBCBCB"))
                        )
                )
        }
        .padding(.top, 20)
    }
    
    //MARK: Password or Otp View
    private var passwordOrOtpView: some View {
        
        VStack(alignment: .leading, spacing: 20) {
           
            // 1. back arrow view
            Button {
                vm.isPassOtpView = !(vm.isPassOtpView)
            } label: {
                Image(systemName: "arrow.left")
                    .fontPoppins(size: 15, weight: .semibold, color: .black)
            }
            
            // 2. title view
            Text((vm.mode == .password) ? "Please enter your password" : "Please enter otp sent to \(vm.emailOrMobile).")
                .fontPoppins(size: 15, weight: .semibold, color: .black)
            
            // 3. password/otp textfield view
            passwordOtpTextField
            
            // 4. switch password/otp option view
            switchOption
            
            // 5. submit button view
            showButtonType(title: "Submit", isEnabled: vm.isSubmitBtnEnabled) {
                handleLoginDetails()
            }

            // 6. Terms & condition view
            LegalTermsFooterView()
        }
    }
    
    private var passwordOtpTextField : some View {
                
        Group {
            switch vm.mode {
            case .password:
                AppPasswordField(text: $vm.passOrOtp)
            case .otp:
                OTPVerificationField(otpCode: $vm.passOrOtp)
            }
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }
    
    private var switchOption: some View {
        HStack(){
            Button {
                
            } label: {
                Text("Resend Otp")
                    .fontPoppins(size: 15, weight: .medium, color: .blue)
                    .opacity((vm.mode == .otp) ? 1.0:0.0)
            }

            Spacer()
            
            Button {
                vm.mode = (vm.mode == .otp) ? .password:.otp
            } label: {
                Text(vm.mode == .otp ? "Password Login or SignUp":"Otp Login or SignUp")
                    .fontPoppins(size: 15, weight: .medium, color: .blue)
            }
        }
    }
    
    private func handleLoginDetails(){
        let user = User(userId: "ramesh01", name: "Ramesh Kumar", email: "rameshkmmmec@gmail.com", phone: "7355026529", address: "Mayur Vihar Phase 3", avatarURL: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80")
        auth.login(user: user, token: "mock_jwt_token_123")
        DispatchQueue.main.async {
            self.onLoginSuccess()
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
