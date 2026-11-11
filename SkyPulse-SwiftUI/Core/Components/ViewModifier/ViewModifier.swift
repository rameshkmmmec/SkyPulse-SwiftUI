//
//  ViewModifier.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 08/11/26.
//

import Foundation
import SwiftUI

enum CardType {
    case rectangle
    case capsule
}

// MARK: - Reusable Modifier
struct CardBorderModifier: ViewModifier {
    var cornerRadius: CGFloat = 8
    var fillColor: Color = .white
    var borderColor: Color = .gray
    var lineWidth: CGFloat = 1
    var cardType: CardType = .rectangle

    @ViewBuilder
    func body(content: Content) -> some View {
        switch cardType {
        case .rectangle:
            content
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(fillColor)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(borderColor, lineWidth: lineWidth)
                )
        case .capsule:
            content
                .background(
                    Capsule()
                        .fill(fillColor)
                )
                .overlay(
                    Capsule()
                        .stroke(borderColor, lineWidth: lineWidth)
                )
        }
    }
}

// MARK: - Convenient View Extension
extension View {
    func cardShape(
        cornerRadius: CGFloat = 8,
        fillColor: Color = .white,
        borderColor: Color = .gray,
        lineWidth: CGFloat = 1,
        cardType: CardType = .rectangle
    ) -> some View {
        self.modifier(
            CardBorderModifier(
                cornerRadius: cornerRadius,
                fillColor: fillColor,
                borderColor: borderColor,
                lineWidth: lineWidth,
                cardType: cardType
            )
        )
    }
}
