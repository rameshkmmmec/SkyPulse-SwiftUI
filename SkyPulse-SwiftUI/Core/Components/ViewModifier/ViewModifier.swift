//
//  ViewModifier.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 08/11/26.
//

import Foundation
import SwiftUI

// MARK: - Reusable Modifier
struct CardBorderModifier: ViewModifier {
    var cornerRadius: CGFloat = 8
    var fillColor: Color = .white
    var borderColor: Color = .gray
    var lineWidth: CGFloat = 1

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(fillColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(borderColor, lineWidth: lineWidth)
            )
    }
}

// MARK: - Convenient View Extension
extension View {
    func rectangleCard(
        cornerRadius: CGFloat = 8,
        fillColor: Color = .white,
        borderColor: Color = .gray,
        lineWidth: CGFloat = 1
    ) -> some View {
        self.modifier(
            CardBorderModifier(
                cornerRadius: cornerRadius,
                fillColor: fillColor,
                borderColor: borderColor,
                lineWidth: lineWidth
            )
        )
    }
}
