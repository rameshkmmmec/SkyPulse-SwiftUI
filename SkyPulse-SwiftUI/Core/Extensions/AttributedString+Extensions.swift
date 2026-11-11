//
//  AttributedString+Extensions.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 12/11/26.
//

import Foundation
import SwiftUI

// MARK: - 1. Clean AttributedString Extension
extension AttributedString {
    static func dualTextStyled(
        primary: StyledTextSegment,
        secondary: StyledTextSegment
    ) -> AttributedString {
        primary.toAttributedString() + secondary.toAttributedString()
    }
}

// MARK: - 2. Lightweight Segment Struct (Heavy Tuples Hataye)
struct StyledTextSegment {
    let text: String
    let size: CGFloat
    let font: AppFont
    let weight: FontWeight
    let color: Color

    func toAttributedString() -> AttributedString {
        var attr = AttributedString(text)
        attr.font = font.font(size: size, weight: weight)
        attr.foregroundColor = color
        return attr
    }
}

// MARK: - 3. Font Resolution moved to Enum (Compile-time fast)
extension AppFont {
    func postScriptName(weight: FontWeight) -> String {
        switch self {
        case .lato:
            switch weight {
            case .regular, .extraBold, .extraLight, .light: return "Lato-Regular"
            case .medium:   return "Lato-Medium"
            case .semibold: return "Lato-Semibold"
            case .bold:     return "Lato-Bold"
            case .thin:     return "Lato-Thin"
            case .black:    return "Lato-Black"
            }
        case .poppins:
            switch weight {
            case .regular:    return "Poppins-Regular"
            case .medium:     return "Poppins-Medium"
            case .semibold:   return "Poppins-SemiBold"
            case .bold:       return "Poppins-Bold"
            case .thin:       return "Poppins-Thin"
            case .black:      return "Poppins-Black"
            case .extraBold:  return "Poppins-ExtraBold"
            case .extraLight: return "Poppins-ExtraLight"
            case .light:      return "Poppins-Light"
            }
        }
    }

    func font(size: CGFloat, weight: FontWeight) -> Font {
        Font.custom(postScriptName(weight: weight), size: size)
    }
}




