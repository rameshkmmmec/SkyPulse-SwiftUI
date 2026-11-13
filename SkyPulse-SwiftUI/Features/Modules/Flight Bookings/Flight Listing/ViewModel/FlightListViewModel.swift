//
//  FlightListViewModel.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 13/11/26.
//

import Foundation
import Combine

final class FlightListViewModel: ObservableObject {
    
    @Published var vm: FlightSearchViewModel
    
    init(vm: FlightSearchViewModel) {
        self.vm = vm
    }

}
