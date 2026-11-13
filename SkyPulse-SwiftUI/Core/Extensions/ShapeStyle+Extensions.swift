//
//  ShapeStyle+Extensions.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 13/11/26.
//

import Foundation
import SwiftUI

extension ShapeStyle where Self == Color {
    static var themeColor: Color { Color.themeColor }
    static var dividerColor: Color { Color.dividerColor }
    static var borderColor: Color { Color.borderColor }
    static var subTitleColor: Color { Color.subTitleColor }
}
