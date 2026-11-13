//
//  FlightSearchViewModel.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 10/11/26.
//

import Foundation
import Combine
import SwiftUI

enum BoundType: Hashable {
    case outbound
    case inbound
}
enum ViewType: Hashable {
    case travelPax
    case travelClass
}

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
    @Published var request: FlightSearchRequest = FlightSearchRequest()
    @Published var tripType: TripType = .oneway
    @Published var activeSheet: ActiveSheetType? = nil

    @Published var activeToast: ToastItem? = nil
    @Published var shouldProceed: Bool = false
    
    init(vm: HomeViewModel) {
        self.vm = vm
    }
    
    var trips: [TripType]{
        return TripType.allCases
    }
    
    var isIntlRt: Bool {
        return !isDomestic && (tripType == .roundtrip)
    }
    
    var isDomestic: Bool {
        let sourceCountry = request.sourceModel.country.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let destCountry = request.destModel.country.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return (sourceCountry == "india") && (destCountry == "india")
    }
    
    func updateJourneyDates(dep: Date, ret: Date?) {
        request.departureDate = dep.toString(format: "dd/MM/yyyy")
        if let returnDate = ret {
            request.returnDate = returnDate.toString(format: "dd/MM/yyyy")
        }
    }
    
    var isSameCity: Bool {
        return (request.sourceModel.cityName == request.destModel.cityName) || (tripType == .roundtrip && request.returnDate == nil)
    }

    var cityInfo: String {
        if tripType == .multicity {
            return "\(request.multiSectors.first?.source?.cityName ?? "") to \(request.multiSectors.last?.dest?.cityName ?? "")"
        }
        return "\(request.sourceModel.cityName) to \(request.destModel.cityName)"
    }
    var detailInfo: String {
        
        if tripType == .multicity {
            let formattedDate = (request.multiSectors.first?.departureDate ?? "").toAnyDateFormat(from: "dd/MM/yyyy", to: "yyyy-MM") ?? ""
            let via = request.via
            let pax = request.tPaxText
            let dText = (via == "") ? ("\(formattedDate) | \(pax)") : ("\(via) | \(formattedDate) | \(pax)")
            
            return dText
        }

        let dep = request.departureDate.toAnyDateFormat(from: "dd/MM/yyyy", to: "E d MMM") ?? ""
        let ret = (request.returnDate ?? "").toAnyDateFormat(from: "dd/MM/yyyy", to: "E d MMM") ?? ""
        
        if (tripType == .oneway) {
            return "\(dep) | \(request.tPaxText)"
        }
        return "\(dep) - \(ret) | \(request.tPaxText)"
    }
    
    
    // 2. Multicity variables/data
    enum SectorType {
        case DepartureType(Int)
        case returnType(Int)
    }
    enum DateType {
        case DepDate(Int)
    }
    
    func updateMultiCityDepartureDate(for selectedIndex: Int, newDate: Date, dateFormat: String = "dd/MM/yyyy") {
        
        request.multiSectors[selectedIndex].departureDate = newDate.toString(format: dateFormat)
        let totalSectors = request.multiSectors.count
        
        for i in (selectedIndex + 1)..<totalSectors {
            let currentSectorDateStr = (request.multiSectors[i].departureDate ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard !currentSectorDateStr.isEmpty, let currentSectorDate = currentSectorDateStr.toDate(format: dateFormat) else {
                continue
            }
            if currentSectorDate < newDate {
                request.multiSectors[i].departureDate = newDate.toString(format: dateFormat)
            }
        }
    }
    
    func getMinimumDepartureDate(for currentIndex: Int, dateFormat: String = "dd/MM/yyyy") -> String {
        // 1. Current index se pichhe (index - 1 down to 0) check karein
        if currentIndex > 0 {
            for i in (0..<currentIndex).reversed() {
                let dateStr = (request.multiSectors[i].departureDate ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                
                // Non-empty aur valid date check
                if !dateStr.isEmpty {
                    return dateStr
                }
            }
        }
        
        // 2. Agar pichhe sab blank/nil mila ya index 0 hai -> Today's date return karein
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: Date())
    }
    
    func validateMultiCitySectors() -> (isValid: Bool, message: String?, invalidIndex: Int?) {
        let sectors = request.multiSectors
        
        // Minimum sectors check (Multi-city me kam se kam 2 sectors hone chahiye)
        guard !sectors.isEmpty else {
            return (false, "Please add sectors for multi-city flight.", 0)
        }
        
        for (index, sector) in sectors.enumerated() {
            let sectorNum = index + 1
            
            if(sector.source == nil) {
                return (false, "Source \(sectorNum) can not be Empty.", sectorNum)
                
            } else if(sector.dest == nil) {
                return (false, "Destination \(sectorNum) can not be Empty.", sectorNum)
                
            }else if (sector.source?.cityName ?? "").caseInsensitiveCompare(sector.dest?.cityName ?? "") == .orderedSame {
                return (false, "Departure and destination cities cannot be same in Sector \(sectorNum).", sectorNum)
                
            }else if (sector.departureDate ?? "").isEmpty {
                return (false, "Departure Date \(sectorNum) can not be Empty.", sectorNum)
            }
        }
        
        return (true, nil, nil)
    }
    
    func swapMultiCityCities(at index: Int) {
        guard request.multiSectors.indices.contains(index) else { return }
        
        // 1. Current Sector ke Source aur Destination ko swap karein
        let tempSource = request.multiSectors[index].source
        request.multiSectors[index].source = request.multiSectors[index].dest
        request.multiSectors[index].dest = tempSource
    }

}


extension FlightSearchViewModel {
    
    // 1. City helper
    func cityTuple(bType: BoundType)-> (String, String, String, String) {
        return (bType == .outbound) ? ("FROM",request.sourceModel.cityName, request.sourceModel.code, request.sourceModel.airportName) : ("TO",request.destModel.cityName, request.destModel.code, request.destModel.airportName)
    }
    
    func cityType(bType: BoundType) -> String{
        return (bType == .outbound) ? "FROM" : "TO"
    }
    func cityCode(bType: BoundType) -> String{
        return (bType == .outbound) ? request.sourceModel.code : request.destModel.code
    }
    func cityName(bType: BoundType) -> String{
        return (bType == .outbound) ? request.sourceModel.cityName : request.destModel.cityName
    }
    func airportName(bType: BoundType) -> String{
        return (bType == .outbound) ? request.sourceModel.airportName : request.destModel.airportName
    }
    
    // 2. Date info
    func travelDateTuples(bType: BoundType) -> (String, String, String) {
        
        let depDatePart1 = request.departureDate.toAnyDateFormat(from: "dd/MM/yyyy", to: "dd MMM")
        let depDatePart2 = request.departureDate.toAnyDateFormat(from: "dd/MM/yyyy", to: "EEE yyyy")
        
        var returnDatePart1 = "Save more on round trips!"
        var returnDatePart2 = ""
        if let returnDt = request.returnDate, (tripType == .roundtrip){
            returnDatePart1 = returnDt.toAnyDateFormat(from: "dd/MM/yyyy", to: "dd MMM")
            returnDatePart2 = returnDt.toAnyDateFormat(from: "dd/MM/yyyy", to: "EEE yyyy")
        }
        
        return (bType == .outbound) ? ("DEPARTURE DATE",depDatePart1,depDatePart2) : ((tripType == .roundtrip ? "RETURN DATE": "+ADD RETURN DATE" ),returnDatePart1,returnDatePart2)
    }
    
    // 3. Update city
    func updateCityModel(city: CityModel?, boundType: BoundType){
        if boundType == .outbound{
            if let updatedCity = city {
                request.sourceModel = updatedCity
            }
        }else {
            if let updatedCity = city {
                request.destModel = updatedCity
            }
        }
        activeSheet = nil
    }
    
    // 4. swap oneway/roundtrip city
    func swapCity() {
        let tempSource = request.sourceModel
        request.sourceModel = request.destModel
        request.destModel = tempSource
    }
    
    func updatePax(adt:Int, chd:Int, inf:Int) {
        request.adults = adt
        request.childs = chd
        request.infants = inf
        activeSheet = nil
    }
    
    var sheetStyle: BottomSheetStyle {
        if (activeSheet == .travelPax || activeSheet == .travelClass){
            return .custom(animationStyle: .slideUp, hasTopCorners: true, showDragIndicator: true)
        }
        return .fullScreen(showDragIndicator: false)
    }
    
    var minDate: Date {
        return (activeSheet == .departureDt) ? Date():request.minimumDate
    }
    var calendarTab: CalendarViewModel.CalendarTab {
        return (activeSheet == .departureDt) ? .departure:.return
    }
    var travellers: String{
        return request.paxCount > 1 ? "\(request.paxCount) Travellers" : "\(request.paxCount) Traveller"
    }
}

