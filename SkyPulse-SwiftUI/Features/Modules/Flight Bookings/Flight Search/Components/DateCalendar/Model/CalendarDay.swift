//
//  CalendarDay.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 12/11/26.
//

import Foundation
import SwiftUI

enum CalendarTab {
    case departure
    case `return`
}

struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date?
    let dayNumber: String
}



