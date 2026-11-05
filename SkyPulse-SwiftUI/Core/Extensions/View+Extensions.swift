//
//  View+Extensions.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 01/11/26.
//

import Foundation
import SwiftUI

extension View {
    
    func fontWith(family: AppFont = .lato, size: CGFloat = 15, weight: FontWeight = .regular, color: Color = .black.opacity(0.75)) -> some View {
        self
            .font(.appFont(family, size: size, weight: weight))
            .foregroundStyle(color)
    }
    
    func fontLato(size: CGFloat = 15, weight: FontWeight = .regular, color: Color = .black.opacity(0.75)) -> some View {
        self
            .font(.withLato(size: size, weight: weight))
            .foregroundStyle(color)
    }
    
    func fontPoppins(size: CGFloat = 15, weight: FontWeight = .regular, color: Color = .black.opacity(0.75)) -> some View {
        self
            .font(.withPoppins(size: size, weight: weight))
            .foregroundStyle(color)
    }

}
