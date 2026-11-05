//
//  HomeViewModel.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 05/11/26.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    @Published var selectedTab: HomeTab = .home
    @Published var dashboardData: DashboardResponse? = nil
    
    init() {
        if let data: DashboardResponse = Bundle.main.decode("dashboard.json"){
            self.dashboardData = data
        }
        print("test")
    }
    
}
