//
//  Color+Extensions.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 05/11/26.
//

import Foundation
import SwiftUI


// hex
extension Color {

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)

        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let red, green, blue, alpha: Double

        switch hex.count {
        case 3: // RGB (FFF)
            red = Double((int >> 8) * 17) / 255
            green = Double(((int >> 4) & 0xF) * 17) / 255
            blue = Double((int & 0xF) * 17) / 255
            alpha = 1

        case 6: // RRGGBB
            red = Double((int >> 16) & 0xFF) / 255
            green = Double((int >> 8) & 0xFF) / 255
            blue = Double(int & 0xFF) / 255
            alpha = 1

        case 8: // AARRGGBB
            alpha = Double((int >> 24) & 0xFF) / 255
            red = Double((int >> 16) & 0xFF) / 255
            green = Double((int >> 8) & 0xFF) / 255
            blue = Double(int & 0xFF) / 255

        default:
            red = 0
            green = 0
            blue = 0
            alpha = 1
        }

        self.init(
            .sRGB,
            red: red,
            green: green,
            blue: blue,
            opacity: alpha
        )
    }
}


