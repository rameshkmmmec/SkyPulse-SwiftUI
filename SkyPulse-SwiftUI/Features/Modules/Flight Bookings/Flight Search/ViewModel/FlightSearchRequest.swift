//
//  FlightSearchRequest.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 11/11/26.
//

import Foundation
 
struct FlightSearchRequest {
    
    // 1. Oneway/Roundtrip parameters
    var sourceModel: CityModel = .sCityModel
    var destModel: CityModel = .dCityModel
    var departureDate: String = DateFormatter.apiDateFormatter.string(from: Date())
    var returnDate: String? = {
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        return DateFormatter.apiDateFormatter.string(from: nextDay)
    }()
    
    var adults: Int = 1
    var childs: Int = 0
    var infants: Int = 0
    var cabin: CabinType = .economy
    
    var paxCount: Int {
        return (adults+childs+infants)
    }
    
    var via: String {
        guard multiSectors.count >= 2 else { return "" }
        let viaCities = multiSectors.dropLast().compactMap { $0.dest?.cityName }
        return "via \(viaCities.joined(separator: ", "))"
    }
    var cityInfo: String {
        return "\(multiSectors.first?.source?.code ?? "") to \(multiSectors.last?.dest?.code ?? "")"
    }
    var departCityInfo: String {
        return "\(sourceModel.cityName) - \(destModel.cityName) | \(departureDate.toAnyDateFormat(from: "dd/MM/yyyy", to: "dd EEE"))"
    }
    var returnCityInfo: String {
        return "\(destModel.cityName) - \(sourceModel.cityName) | \((returnDate ?? "").toAnyDateFormat(from: "dd/MM/yyyy", to: "dd EEE"))"
    }
    var minimumDate: Date {
        return (departureDate.toDate() ?? Date())
    }
    var tPaxText: String {
        var components: [String] = []
        components.append("\(adults) Adult\(adults > 1 ? "s" : "")")

        if childs > 0 {
            components.append("\(childs) \(childs == 1 ? "Child" : "Children")")
        }
        if infants > 0 {
            components.append("\(infants) Infant\(infants > 1 ? "s" : "")")
        }
        return components.joined(separator: ", ")
    }
    
    // 2. Multicity parameters
    var multiSectors: [MultiSector] = [
        MultiSector(source: .sCityModel, dest: .dCityModel),
        MultiSector(source: .dCityModel, dest: nil)
    ]
    
    mutating func addSectors(at index:Int){
        let newSector = MultiSector(source: nil, dest: nil)
        if multiSectors.count > 0 {
            multiSectors.insert(newSector, at: index)
        } else {
            multiSectors.append(newSector)
        }
    }
    
    mutating func removeSector(from index: Int){
        if multiSectors.count > 0{
            multiSectors.remove(at: index)
        }
    }
}


enum CabinType: String, CaseIterable, Identifiable {
    
    case economy = "Economy"
    case premiumEconomy = "Premium Economy"
    case business = "Business"
    case firstClass = "First Class"
    
    var id: String { rawValue }
}

struct MultiSector: Identifiable {
    
    let id = UUID()
    var source: CityModel?
    var dest: CityModel?
    var departureDate: String?
}

enum ActiveSheetType: Identifiable, Equatable {
    case sourcCity
    case destCity
    case departureDt
    case arrivalDt
    case sourceCity(index: Int)
    case destinationCity(index: Int)
    case departureDate(index: Int)
    case travelPax
    case travelClass

    var id: String {
        switch self {
        case .sourcCity: return "source"
        case .destCity: return "dest"
        case .departureDt: return "depDtae"
        case .arrivalDt: return "arrDate"
        case .sourceCity(let i):      return "src_\(i)"
        case .destinationCity(let i): return "dest_\(i)"
        case .departureDate(let i):   return "dep_\(i)"
        case .travelPax: return "tvl_pax"
        case .travelClass: return "tvl_class"
        }
    }
}

extension DateFormatter {
    static let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()
}
