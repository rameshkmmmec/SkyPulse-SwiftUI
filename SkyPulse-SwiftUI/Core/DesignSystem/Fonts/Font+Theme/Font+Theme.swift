//
//  Font+Theme.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 05/11/26.
//

import Foundation
import SwiftUI

enum AppFont {
    case lato
    case poppins
}

enum FontWeight {
    case regular
    case medium
    case semibold
    case bold
    case extraBold
    case black
    case thin
    case extraLight
    case light
}


extension Font {
    
    // common function
    static func appFont(_ family:AppFont, size: CGFloat, weight: FontWeight = .regular) -> Font {
        let postScriptName = getPostScriptName(family: family, weight: weight)
        return Font.custom(postScriptName, size: size)
    }
    
    // lato
    static func withLato(size: CGFloat, weight: FontWeight = .regular) -> Font {
        return appFont(.lato, size: size, weight: weight)
    }
    
    // poppins
    static func withPoppins(size: CGFloat, weight: FontWeight = .regular) -> Font {
        return appFont(.poppins, size: size, weight: weight)
    }

    // MARK: - PostScript Name Resolver
     static func getPostScriptName(family: AppFont, weight: FontWeight) -> String {
        switch family {
        case .lato:
            switch weight {
            case .regular:  return "Lato-Regular"
            case .medium:   return "Lato-Medium"
            case .semibold: return "Lato-Semibold"
            case .bold:     return "Lato-Bold"
            case .thin:     return "Lato-Thin"
            case .black:    return "Lato-Black"
                
            case .extraBold:  return "Lato-Regular"
            case .extraLight: return "Lato-Regular"
            case .light:      return "Lato-Regular"
            }
            
        case .poppins:
            switch weight {
            case .regular:  return "Poppins-Regular"
            case .medium:   return "Poppins-Medium"
            case .semibold: return "Poppins-SemiBold"
            case .bold:     return "Poppins-Bold"
            case .thin:       return "Poppins-Thin"
            case .black:      return "Poppins-Black"
            case .extraBold:  return "Poppins-ExtraBold"
            case .extraLight: return "Poppins-ExtraLight"
            case .light:      return "Poppins-Light"
            }
        }
    }
}
