//
//  LinearGradient+Extensions.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 08/11/26.
//

import Foundation
import SwiftUI
import UIKit

extension LinearGradient {
    @MainActor
    static func skyPrimary(
        startColor: Color,
        endColor: Color,
        startPoint: UnitPoint = .leading,
        endPoint: UnitPoint = .trailing
    ) -> LinearGradient {
        LinearGradient(
            colors: [startColor, endColor],
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
    
    // Default call ke liye overload (yahan body @MainActor isolated hoti hai)
    @MainActor
    static func skyPrimary(
        startPoint: UnitPoint = .leading,
        endPoint: UnitPoint = .trailing
    ) -> LinearGradient {
        skyPrimary(
            startColor: Color(hex: "#53B2FE"),
            endColor: Color(hex: "#065AF3"),
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
    
    @MainActor
    static var themeGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: "#74CDE0"), // Light bright shade (Left)
                Color(hex: "#57B4C7"), // Base color (Center)
                Color(hex: "#328FA4")  // Deep rich shade (Right)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}


