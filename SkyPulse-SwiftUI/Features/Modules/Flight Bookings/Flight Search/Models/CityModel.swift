//
//  CityModel.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 11/11/26.
//

import Foundation

struct CityModel: Codable, Identifiable, Hashable {

    let id: UUID = UUID()
    let jsonId: Int?
    let city: String
    let type: String?
    let country: String
    let airportName: String
    let showCity: String
    let countryCounter: Int
    let cityName: String
    let nearByCity: [CityModel]?

    enum CodingKeys: String, CodingKey {
        case jsonId = "Id"
        case city = "City"
        case type = "Type"
        case country = "Country"
        case airportName = "AirportName"
        case showCity = "ShowCity"
        case countryCounter = "CountryCounter"
        case cityName = "CityName"
        case nearByCity
    }
    
    var code: String {
        guard let start = city.firstIndex(of: "("),
              let end = city.firstIndex(of: ")"),
              start < end else {
            return city
        }
        let codeRange = city.index(after: start)..<end
        return String(city[codeRange])
    }
    
    var cityCode: String? {
        let parts = showCity.components(separatedBy: "-")
        if let code = parts.first?.trimmingCharacters(in: .whitespaces) {
            return code // Output: "HDO"
        }
        return nil
    }
    
}

extension CityModel {

    static let sCityModel = CityModel(
        jsonId: 0,
        city: "DEL",
        type: nil,
        country: "India",
        airportName: "Indira Gandhi International Airport",
        showCity: "DEL-New Delhi, India",
        countryCounter: 8,
        cityName: "Delhi",
        nearByCity: []
    )

    static let dCityModel = CityModel(
        jsonId: 0,
        city: "BOM",
        type: nil,
        country: "India",
        airportName: "Chhatrapati Shivaji Maharaj International Airport",
        showCity: "BOM-Mumbai, India",
        countryCounter: 6,
        cityName: "Mumbai",
        nearByCity: []
    )
}
