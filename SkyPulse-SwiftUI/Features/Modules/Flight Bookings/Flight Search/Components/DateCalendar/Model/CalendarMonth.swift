//
//  CalendarMonth.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 12/11/26.
//

import Foundation
import SwiftUI

struct CalendarMonth: Identifiable {
    let id: String // e.g. "2026-12"
    let date: Date
    let name: String // "October 2026"
    let days: [CalendarDay]
}
