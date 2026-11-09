//
//  FlightSearchViewModel.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 10/11/26.
//

import Foundation
import Combine

enum TripType: String, Identifiable, Equatable, CaseIterable {
    case oneway = "Oneway"
    case roundtrip = "Roundtrip"
    case multicity = "Multicity"
    
    var id: String {
        rawValue
    }
}

final class FlightSearchViewModel: ObservableObject {
    
    @Published var vm: HomeViewModel
    @Published var tripType: TripType = .oneway
    
    init(vm: HomeViewModel) {
        self.vm = vm
    }
    
    var trips: [TripType]{
        return TripType.allCases
    }
}
