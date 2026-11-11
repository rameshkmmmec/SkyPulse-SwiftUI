//
//  CityViewModel.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 11/11/26.
//

import Foundation
import Combine

final class CityViewModel: ObservableObject {
    
    @Published var sourceText: String = ""
    @Published var destText: String = ""
    @Published var sourceModel: CityModel?
    @Published var destModel: CityModel?
    
    
    @Published var allCities: [CityModel] = []
    @Published var boundType: BoundType = .outbound
    @Published var searchText: String = ""
    
    init(source: CityModel? = nil, dest: CityModel? = nil, bType: BoundType) {
        sourceModel = source
        destModel = dest
        boundType = bType
                
        if let cityList: [CityModel] = Bundle.main.decode("cities.json"){
            self.allCities = cityList
        }
    }
    
    func isCityDisabled( city: CityModel) -> Bool {
        let targetCode = city.code
        if boundType == .outbound {
            guard let sourceCity = sourceModel else { return false }
            return (sourceCity.code == targetCode)
        } else {
            guard let destCity = destModel else { return false }
            return (destCity.code == targetCode)
        }
    }
    
    var cities: [CityModel] {
        
        var activeText = (boundType == .outbound) ? sourceText:destText
        let query = activeText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        guard !query.isEmpty else { return allCities}
        
        return allCities.filter { city in
            city.code.lowercased().contains(query) ||
            city.cityName.lowercased().contains(query) ||
            city.airportName.lowercased().contains(query)
        }
    }
}
