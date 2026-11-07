//
//  FloatingTextField.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 08/11/26.
//

import Foundation
import SwiftUI

struct FloatingTextField: View {
    let title: String
    @Binding var text: String
    var icon: String? = nil
    var isSecure: Bool = false
    var errorMessage: String? = nil
    
    // Focus state track karne ke liye
    @FocusState private var isFocused: Bool
    @State private var isPasswordVisible: Bool = false
    
    private var isFloating: Bool {
        isFocused || !text.isEmpty
    }
    
    // Theme Colors
    private let activeColor = Color(hex: "#00E5FF") ?? .cyan
    private let errorColor = Color(hex: "#FF453A") ?? .red
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .leading) {
                // MARK: - Floating Placeholder Label
                Text(title)
                    .font(.system(size: isFloating ? 11 : 15, weight: isFloating ? .medium : .regular))
                    .foregroundColor(
                        errorMessage != nil ? errorColor : (isFocused ? activeColor : .gray)
                    )
                    .offset(x: (icon != nil && !isFloating) ? 32 : 0, y: isFloating ? -20 : 0)
                    .animation(.spring(response: 0.25, dampingFraction: 0.8), value: isFloating)
                    .allowsHitTesting(false)
                
                // MARK: - Input Field Layer
                HStack(spacing: 10) {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 16))
                            .foregroundColor(isFocused ? activeColor : .gray)
                            .frame(width: 22)
                    }
                    
                    if isSecure && !isPasswordVisible {
                        SecureField("", text: $text)
                            .focused($isFocused)
                            .foregroundColor(.white)
                    } else {
                        TextField("", text: $text)
                            .focused($isFocused)
                            .foregroundColor(.white)
                    }
                    
                    // Secure toggle button
                    if isSecure {
                        Button {
                            isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.top, isFloating ? 14 : 0) // Text field ko thoda niche space deta hai
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white.opacity(0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(
                        errorMessage != nil ? errorColor : (isFocused ? activeColor : Color.white.opacity(0.12)),
                        lineWidth: isFocused ? 1.5 : 1
                    )
            )
            
            // MARK: - Error Label
            if let error = errorMessage {
                Text(error)
                    .font(.system(size: 12))
                    .foregroundColor(errorColor)
                    .padding(.leading, 4)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: errorMessage)
    }
}
