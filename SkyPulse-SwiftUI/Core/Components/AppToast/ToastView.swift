//
//  ToastView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 13/11/26.
//

import Foundation
import SwiftUI

// MARK: - 1. Custom Slide & Fade Transition
extension AnyTransition {
    static var toastSlide: AnyTransition {
        .asymmetric(
            // Appear: Niche (+24pt) se upar move karega aur fade-in hoga
            insertion: .offset(y: 15).combined(with: .opacity),
            // Disappear: Wapas niche (+24pt) move karega aur fade-out hoga
            removal: .offset(y: 15).combined(with: .opacity)
        )
    }
}
//extension AnyTransition {
//    static var toastSlide: AnyTransition {
//        .asymmetric(
//            insertion: .offset(y: 20).combined(with: .opacity),
//            removal: .offset(y: 20).combined(with: .opacity)
//        )
//    }
//}

// MARK: - 2. Toast View Modifier
struct BottomToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    
    // 1. msg properties
    let message: String
    var msgColor: Color = .white
    var mFont: CGFloat = 15
    var mWeight: Font.Weight = .semibold
    
    // 2. duration & padding
    var duration: Double = 5.0
    var bottomPadding: CGFloat = 100 // Bottom sheet/bar ke hisaab se adjust karein
    
    // 3. image properties
    var imgName: String = "checkmark.circle.fill"
    var imgColor: Color = .green
    
    // 4. background color
    var bgColor = Color(red: 0.22, green: 0.24, blue: 0.28)
    var vSpace: CGFloat = 25

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if isPresented {
                    HStack(spacing: 12) {
                        // Green Checkmark
                        Image(systemName: imgName)
                            .foregroundColor(imgColor)
                            .font(.system(size: 20))

                        // Message Text
                        Text(message)
                            .font(.system(size: mFont, weight: mWeight))
                            .foregroundColor(msgColor)

                        Spacer(minLength: 2)

                        // Close Button
                        Button(action: {
                            withAnimation(.spring(response: 0.55, dampingFraction: 0.85)) {
                            //withAnimation(.easeInOut(duration: 0.35)) {
                                isPresented = false
                            }
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: 14, weight: .medium))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, vSpace)
                    .background(bgColor)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 16)
                    .padding(.bottom, bottomPadding)
                    
                    .transition(
                        .asymmetric(
                            insertion: .offset(y: 20).combined(with: .opacity),
                            removal: .offset(y: 20).combined(with: .opacity)
                        )
                    )
                    .task(id: isPresented) {
                        if isPresented {
                            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                            withAnimation(.spring(response: 0.55, dampingFraction: 0.85)) {
                            //withAnimation(.easeInOut(duration: 0.35)) {
                                isPresented = false
                            }
                        }
                    }
                }
            }
            .animation(.spring(response: 0.6, dampingFraction: 0.85), value: isPresented)
    }
}


// MARK: - 3. View Extension
extension View {
    func displayToast(isPresented: Binding<Bool>, message: String, msgColor:Color = .white, mFont: CGFloat = 15, mWeight: Font.Weight = .semibold, duration: Double = 3.0, bottomPadding: CGFloat = 100, imgName: String = "checkmark.circle.fill", imgColor: Color = .green, bgColor: Color = Color(red: 0.22, green: 0.24, blue: 0.28), vSpace: CGFloat = 25) -> some View {
        self.modifier(
            BottomToastModifier(
                isPresented: isPresented,
                message: message,
                msgColor: msgColor,
                mFont: mFont,
                mWeight: mWeight,
                duration: duration,
                bottomPadding: bottomPadding,
                imgName: imgName,
                imgColor: imgColor,
                bgColor: bgColor,
                vSpace: vSpace
            )
        )
    }
}


// ============================ ************** ============================


struct ToastItem: Identifiable, Equatable {
    let id = UUID()
    let message: String
    var msgColor: Color = .white
    var mFont: CGFloat = 15
    var mWeight: Font.Weight = .semibold
    var duration: Double = 3.0
    var bottomPadding: CGFloat = 100
    var imgName: String = "checkmark.circle.fill"
    var imgColor: Color = .green
    var bgColor: Color = Color(red: 0.22, green: 0.24, blue: 0.28)
    var vSpace: CGFloat = 25
    
    // Convenience presets (Success / Warning / Error)
    static func success(_ message: String, duration: Double = 3.0, bottomPadding: CGFloat = 100) -> ToastItem {
        ToastItem(
            message: message,
            duration: duration,
            bottomPadding: bottomPadding,
            imgName: "checkmark.circle.fill",
            imgColor: .green
        )
    }
    
    static func warning(_ message: String, duration: Double = 3.0, bottomPadding: CGFloat = 100) -> ToastItem {
        ToastItem(
            message: message,
            duration: duration,
            bottomPadding: bottomPadding,
            imgName: "exclamationmark.circle.fill",
            imgColor: .yellow
        )
    }
    
    static func error(_ message: String, duration: Double = 3.0, bottomPadding: CGFloat = 100) -> ToastItem {
        ToastItem(
            message: message,
            duration: duration,
            bottomPadding: bottomPadding,
            imgName: "xmark.circle.fill",
            imgColor: .red
        )
    }
}

// ===================================  ITEM BASED TOAST  ======================================

struct BottomToastItemModifier<Item: Identifiable & Equatable>: ViewModifier {
    @Binding var item: Item?
    let toastProvider: (Item) -> ToastItem
    
    func body(content: Content) -> some View {
        let currentToast = item.map(toastProvider)
        
        content
            .overlay(alignment: .bottom) {
                if let activeItem = item, let toast = currentToast {
                    HStack(spacing: 12) {
                        Image(systemName: toast.imgName)
                            .foregroundColor(toast.imgColor)
                            .font(.system(size: 20))
                        
                        Text(toast.message)
                            .font(.system(size: toast.mFont, weight: toast.mWeight))
                            .foregroundColor(toast.msgColor)
                        
                        Spacer(minLength: 2)
                        
                        Button {
                            withAnimation(.spring(response: 0.55, dampingFraction: 0.85)) {
                                item = nil
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: 14, weight: .medium))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, toast.vSpace)
                    .background(toast.bgColor)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 16)
                    .padding(.bottom, toast.bottomPadding)
                    .transition(.toastSlide)
                    .id(activeItem.id)
                    .task(id: activeItem.id) {
                        try? await Task.sleep(nanoseconds: UInt64(toast.duration * 1_000_000_000))
                        guard !Task.isCancelled else { return }
                        withAnimation(.spring(response: 0.55, dampingFraction: 0.85)) {
                            if item?.id == activeItem.id {
                                item = nil
                            }
                        }
                    }
                }
            }
            .animation(.spring(response: 0.6, dampingFraction: 0.85), value: item)
    }
}

extension View {
    
    // 1. Direct ToastItem binding ke liye
    func displayToast(item: Binding<ToastItem?>) -> some View {
        self.modifier(
            BottomToastItemModifier(item: item) { $0 }
        )
    }
    
    // 2. Kisi bhi custom Identifiable & Equatable item/enum ko ToastItem me map karne ke liye
    func displayToast<Item: Identifiable & Equatable>(
        item: Binding<Item?>,
        content: @escaping (Item) -> ToastItem
    ) -> some View {
        self.modifier(
            BottomToastItemModifier(item: item, toastProvider: content)
        )
    }
}
