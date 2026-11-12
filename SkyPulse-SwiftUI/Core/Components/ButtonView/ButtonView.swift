//
//  ButtonView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 12/11/26.
//

import Foundation
import SwiftUI

struct RadioButtonView: View {
    let isSelected: Bool
    var size: CGFloat = 20
    var activeColor: Color = Color(red: 71/255, green: 145/255, blue: 232/255) // #4791E8
    var inactiveColor: Color = Color(red: 71/255, green: 145/255, blue: 232/255) // #4791E8

    var body: some View {
        ZStack {
            // Outer Ring
            Circle()
                .strokeBorder(isSelected ? activeColor : inactiveColor, lineWidth: 1)
                .frame(width: size, height: size)
            
            // Inner Filled Dot
            if isSelected {
                Circle()
                    .fill(activeColor)
                    //.frame(width: size * 0.55, height: size * 0.55)
                    .frame(width: size * 0.65, height: size * 0.65)

            }
        }
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}
