//
//  BottomSheet.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 08/11/26.
//

import Foundation
import SwiftUI

enum BottomSheetAnimation {
    case slideUp   // Smooth bottom slide (iOS native feel)
    case fade      // Clean fade-in / fade-out
}

struct CustomBottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let detentHeight: CGFloat?
    let animationStyle: BottomSheetAnimation
    let hasTopCorners: Bool
    let showDragIndicator: Bool
    @ViewBuilder let sheetContent: () -> SheetContent
    
    @State private var dragOffset: CGFloat = 0
    
    private let sheetAnimation: Animation = .interpolatingSpring(stiffness: 300, damping: 30)
    
    init(
        isPresented: Binding<Bool>,
        height: CGFloat? = nil,
        animationStyle: BottomSheetAnimation = .slideUp,
        hasTopCorners: Bool = true,
        showDragIndicator: Bool = true,
        @ViewBuilder content: @escaping () -> SheetContent
    ) {
        self._isPresented = isPresented
        self.detentHeight = height
        self.animationStyle = animationStyle
        self.hasTopCorners = hasTopCorners
        self.showDragIndicator = showDragIndicator
        self.sheetContent = content
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            // Main Screen Content
            content
            
            // Dimmed Overlay
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismiss()
                    }
                    .transition(.opacity)
                    .zIndex(1)
            }
            
            // Bottom Sheet Surface
            if isPresented {
                VStack(spacing: 0) {
                    // 1. Drag Indicator
                    if showDragIndicator {
                        Capsule()
                            .fill(Color.gray.opacity(0.35))
                            .frame(width: 36, height: 4)
                            .padding(.top, 10)
                            .padding(.bottom, 6)
                    }
                    
                    // 2. Injected Content
                    sheetContent()
                    
                    // 3. ZERO-DELAY SAFE AREA SHIELD (Solid White Extension)
                    // Yeh safe-area ke gap ko sheet ke sath hi slide karwayega
                    Color.white
                        .frame(height: 60)
                }
                .frame(maxWidth: .infinity)
                .frame(height: detentHeight)
                .background(
                    Color.white
                        .cornerRadius(hasTopCorners ? 20 : 0, corners: [.topLeft, .topRight])
                )
                // 60pt extension ko screen edge ke neeche chhipa diya
                .padding(.bottom, -60)
                .offset(y: max(0, dragOffset))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.height > 0 {
                                dragOffset = value.translation.height
                            }
                        }
                        .onEnded { value in
                            if value.translation.height > 70 {
                                dismiss()
                            } else {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                    dragOffset = 0
                                }
                            }
                        }
                )
                .transition(sheetTransition)
                .zIndex(2)
            }
        }
        .animation(sheetAnimation, value: isPresented)
    }
    
    private var sheetTransition: AnyTransition {
        switch animationStyle {
        case .slideUp:
            return .move(edge: .bottom)
        case .fade:
            return .opacity.combined(with: .scale(scale: 0.96))
        }
    }
    
    private func dismiss() {
        withAnimation(sheetAnimation) {
            isPresented = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            dragOffset = 0
        }
    }
}


extension View {
    
    // 1. Bool-based modifier
    func customBottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        height: CGFloat? = nil,
        animationStyle: BottomSheetAnimation = .slideUp,
        hasTopCorners: Bool = true,
        showDragIndicator: Bool = true, // Default true
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(
            CustomBottomSheetModifier(
                isPresented: isPresented,
                height: height,
                animationStyle: animationStyle,
                hasTopCorners: hasTopCorners,
                showDragIndicator: showDragIndicator,
                content: content
            )
        )
    }
    
    // 2. New Item-based modifier (Supports Enum / Model / SectorType / DateType)
    func customBottomSheet<Item: Identifiable, Content: View>(
        item: Binding<Item?>,
        height: CGFloat? = nil,
        animationStyle: BottomSheetAnimation = .slideUp,
        hasTopCorners: Bool = true,
        showDragIndicator: Bool = true,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        self.modifier(
            CustomBottomSheetItemModifier(
                item: item,
                detentHeight: height,
                animationStyle: animationStyle,
                hasTopCorners: hasTopCorners,
                showDragIndicator: showDragIndicator,
                sheetContent: content
            )
        )
    }
    
    func fullBottomSheet<Item: Identifiable, Content: View>(
        item: Binding<Item?>,
        showDragIndicator: Bool = false,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        self.modifier(
            FullBottomSheetItemModifier(
                item: item,
                showDragIndicator: showDragIndicator,
                sheetContent: content
            )
        )
    }
}

struct RoundedCornerShape: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


//============================== BOTTOM SHEET CONTENT BASED ================ //

struct CustomBottomSheetItemModifier<Item: Identifiable, SheetContent: View>: ViewModifier {
    @Binding var item: Item?
    let detentHeight: CGFloat?
    let animationStyle: BottomSheetAnimation
    let hasTopCorners: Bool
    let showDragIndicator: Bool
    @ViewBuilder let sheetContent: (Item) -> SheetContent
    
    @State private var dragOffset: CGFloat = 0
    private let sheetAnimation: Animation = .interpolatingSpring(stiffness: 300, damping: 30)
    
    private var isPresented: Bool {
        item != nil
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            // Main Screen Content
            content
            
            // Dimmed Overlay
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismiss()
                    }
                    .transition(.opacity)
                    .zIndex(1)
            }
            
            // Bottom Sheet Surface
            if let currentItem = item {
                VStack(spacing: 0) {
                    // 1. Drag Indicator
                    if showDragIndicator {
                        Capsule()
                            .fill(Color.gray.opacity(0.35))
                            .frame(width: 36, height: 4)
                            .padding(.top, 10)
                            .padding(.bottom, 6)
                    }
                    
                    // 2. Injected Content with unwrapped Item
                    sheetContent(currentItem)
                    
                    // 3. ZERO-DELAY SAFE AREA SHIELD (Solid White Extension)
                    Color.white
                        .frame(height: 60)
                }
                .frame(maxWidth: .infinity)
                .frame(height: detentHeight)
                .background(
                    Color.white
                        .clipShape(RoundedCornerShape(radius: hasTopCorners ? 20 : 0, corners: [.topLeft, .topRight]))
                )
                .padding(.bottom, -60)
                .offset(y: max(0, dragOffset))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.height > 0 {
                                dragOffset = value.translation.height
                            }
                        }
                        .onEnded { value in
                            if value.translation.height > 70 {
                                dismiss()
                            } else {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                    dragOffset = 0
                                }
                            }
                        }
                )
                .transition(sheetTransition)
                .zIndex(2)
            }
        }
        .animation(sheetAnimation, value: isPresented)
    }
    
    private var sheetTransition: AnyTransition {
        switch animationStyle {
        case .slideUp:
            return .move(edge: .bottom)
        case .fade:
            return .opacity.combined(with: .scale(scale: 0.96))
        }
    }
    
    private func dismiss() {
        withAnimation(sheetAnimation) {
            item = nil
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            dragOffset = 0
        }
    }
}


//============================== FULL SCREEN BOTTOM SHEET CONTENT BASED ================ //


struct FullBottomSheetItemModifier<Item: Identifiable, SheetContent: View>: ViewModifier {
    @Binding var item: Item?
    var showDragIndicator: Bool = true
    @ViewBuilder let sheetContent: (Item) -> SheetContent
    
    @State private var dragOffset: CGFloat = 0
    private let springAnimation: Animation = .spring(response: 0.50, dampingFraction: 0.86)
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            // Main Screen Content
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Dimmed Overlay
            if item != nil {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismiss()
                    }
                    .transition(.opacity)
                    .zIndex(1)
            }
            
            // Full Bottom Sheet Surface
            if let currentItem = item {
                VStack(spacing: 0) {
                    // 1. Drag Indicator (Agar true hai toh aayega)
                    if showDragIndicator {
                        Capsule()
                            .fill(Color.gray.opacity(0.35))
                            .frame(width: 38, height: 5)
                            .padding(.top, 8)
                            .padding(.bottom, 6)
                    }
                    
                    // 2. Sheet Content (Aapka UI aur List)
                    sheetContent(currentItem)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Color(.systemBackground)
                        .clipShape(RoundedCornerShape(radius: 20, corners: [.topLeft, .topRight]))
                        .ignoresSafeArea()
                )
                .offset(y: max(0, dragOffset))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.height > 0 {
                                dragOffset = value.translation.height
                            }
                        }
                        .onEnded { value in
                            if value.translation.height > 120 {
                                dismiss()
                            } else {
                                withAnimation(springAnimation) {
                                    dragOffset = 0
                                }
                            }
                        }
                )
                .transition(.move(edge: .bottom))
                .zIndex(2)
            }
        }
        .animation(springAnimation, value: item != nil)
    }
    
    private func dismiss() {
        withAnimation(springAnimation) {
            item = nil
            dragOffset = 0
        }
    }
}




