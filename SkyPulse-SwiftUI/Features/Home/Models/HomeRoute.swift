//
//  HomeRoute.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 05/11/26.
//

import Foundation
import UIKit

enum HomeRoute: Hashable {
    case myTrips
    case wallet
    case offers
    case notifications
    case settings
    case support
    case profile
    
    case module(id: String)
    
    var hideTabbar: Bool {
        switch self {
        case .wallet, .offers, .notifications, .settings, .support, .module(_):
            return true
        case .myTrips, .profile:
            return false
        }
    }
}
