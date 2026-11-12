//
//  CalendarViewModel.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 12/11/26.
//

import Foundation
import Combine


final class CalendarViewModel: ObservableObject {
    
    let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    @Published var departureDate: Date? = Date()
    @Published var returnDate: Date? = nil
    @Published var minSelectableDate: Date? = nil
    @Published var activeTab: CalendarTab = .departure
    @Published var tripType: TripType
    
    @Published var months: [CalendarMonth] = []
    
    let calendar = Calendar.current
    
    enum CalendarTab {
        case departure
        case `return`
        case multicity
    }

    init(minimumDate: Date, departureDate: Date? = Date(), returnDate: Date? = nil, activeTab: CalendarTab = .departure, tripType: TripType) {
        
        self.minSelectableDate = minimumDate
        self.departureDate = departureDate
        self.returnDate = returnDate
        self.activeTab = activeTab
        self.tripType = tripType
        
        self.generateUpcomingMonths()
    }
    
    var departureDt: String {
        return departureDate?.toString(format: "E MMM dd yyyy") ?? ""
    }
    var returnDt: String {
        return returnDate?.toString(format: "E MMM dd yyyy") ?? ""
    }
    
    // Effective minimum date: Agar minSelectableDate di hai toh wo, varna Today
    var effectiveMinDate: Date {
        let today = calendar.startOfDay(for: Date())
        if let minDate = minSelectableDate {
            let startOfMin = calendar.startOfDay(for: minDate)
            return max(startOfMin, today) // Today se purani nahi honi chahiye
        }
        return today
    }
    
    // Scroll target: Departure date ho ya effective minimum date
    var targetMonthId: String {
        let target = departureDate ?? effectiveMinDate
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: target)
    }
    func monthID(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }

    // 1. Upcoming Calendar Months
    private func generateUpcomingMonths(from startDate: Date = Date()) {
        
        var calendarMonths: [CalendarMonth] = []
        let today = calendar.startOfDay(for: startDate)
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM yyyy"
        monthFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let idFormatter = DateFormatter()
        idFormatter.dateFormat = "yyyy-MM"
        idFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let currentMonthIntervel = calendar.dateInterval(of: .month, for: today) else {
            return
        }
        var currentMonthStart = currentMonthIntervel.start
        
        for _ in 0..<12{
            let monthId = idFormatter.string(from: currentMonthStart)
            let monthName = monthFormatter.string(from: currentMonthStart)
            let days = generateDays(for: currentMonthStart)
            
            calendarMonths.append(CalendarMonth(id: monthId, date: currentMonthStart, name: monthName, days: days))
            
            if let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonthStart) {
                currentMonthStart = nextMonth
            }
        }
        months = calendarMonths
    }
    
    // 2. Generate monthwise caledar dates
    private func generateDays(for monthDate: Date) -> [CalendarDay] {
        
        guard let range = calendar.range(of: .day, in: .month, for: monthDate),
              let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: monthDate)) else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let emptyLeadingCount = firstWeekday - 1
        var days: [CalendarDay] = []
        
        //to add ghost box in begening before start the first date
        for _ in 0..<emptyLeadingCount{
            days.append(CalendarDay(date: nil, dayNumber: ""))
        }
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day-1, to: firstDayOfMonth){
                days.append(CalendarDay(date: date, dayNumber: "\(day)"))
            }
        }
        
        //to add ghost box at the end of last date
        let targetTotalSlots = days.count > 35 ? 42 : 35
        let trailingCount = max(0, targetTotalSlots - days.count)
        for _ in 0..<trailingCount{
            days.append(CalendarDay(date: nil, dayNumber: ""))
        }
        
        return days
    }
        
    
}
