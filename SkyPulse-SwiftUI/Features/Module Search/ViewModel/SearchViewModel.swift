//
//  SearchViewModel.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 10/11/26.
//

import Foundation
import Combine

enum ModuleType: String {
    case flight = "Flights"
    case hotel = "Hotels"
    case train = "Trains"
    case cab = "Cabs"
}


final class SearchViewModel: ObservableObject {
    
    @Published var viewModel: HomeViewModel
    @Published var mType: ModuleType = .flight
    @Published var modules: [QuickActionItem] = []
    
    init(viewModel: HomeViewModel, mId: String) {
        self.viewModel = viewModel
        
        if let homeData = viewModel.dashboardData?.homePage{
            for module in homeData.modules {
                switch module.content {
                case .gridActions(_, let items):
                    modules = items
                    
                    self.modules = items.map { item in
                        var updatedItem = item
                        updatedItem.isSelected = (item.id == mId)
                        return updatedItem
                    }
                    if let selectedTitle = self.modules.first(where: { $0.isSelected })?.title {
                        self.mType = ModuleType(rawValue: selectedTitle) ?? .flight
                    }
                    
                default:
                    break
                }
            }
        }
    }
}
