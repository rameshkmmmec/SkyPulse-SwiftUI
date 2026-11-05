//
//  HomeTab.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 05/11/26.
//

import Foundation
import UIKit

enum HomeTab: String, CaseIterable {
    
    case home = "Home"
    case myprofile = "Profile"
    case mybooking = "MyTrips"
    
    var image: String {
        
        switch self {
        case .home:
            return "house.fill"
        case .myprofile:
            return "person.crop.circle"
        case .mybooking:
            return "suitcase.fill"
        }
    }
}
