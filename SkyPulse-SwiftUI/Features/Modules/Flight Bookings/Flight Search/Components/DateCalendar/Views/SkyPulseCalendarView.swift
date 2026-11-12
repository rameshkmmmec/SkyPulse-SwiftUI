//
//  SkyPulseCalendarView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 12/11/26.
//

import Foundation
import SwiftUI

struct SkyPulseCalendarView: View {
    
    @StateObject var viewModel: CalendarViewModel
    let onConfirm: (Date, Date?) -> Void
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 3), count: 7)
    private let themeBlue = Color(hex: "#57B4C7")//Color.init(hex: "#2093EF")
    
    @State private var isReady: Bool = false
    
    init(minimumDate: Date, departureDate: Date? = Date(), returnDate: Date? = nil, startTab: CalendarViewModel.CalendarTab = .departure, tripType:TripType, onConfirm: @escaping (Date, Date?) -> Void
    ) {
        self.onConfirm = onConfirm
        _viewModel = StateObject(wrappedValue: CalendarViewModel(
            minimumDate: minimumDate,
            departureDate: departureDate,
            returnDate: returnDate,
            activeTab: startTab,
            tripType: tripType
        ))
    }
    
    var body: some View {

        VStack(spacing: 0) {
            
            headerView()
            
            HStack {
                ForEach(viewModel.weekdays.indices, id: \.self) { idx in
                    Text(viewModel.weekdays[idx])
                        .fontPoppins(size: 18, weight: .regular, color: .black.opacity(0.85))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 10)
            .background(Color.init(hex: "#E0E0E0"))
            
            Rectangle()
                .fill(Color.blue.opacity(0.55))
                .frame(height: 0.5)

            ScrollViewReader { proxy in
                
                 //12 Months Scrollable Calendar
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.months) { month in
                            VStack(spacing: 0){
                                
                                Text(month.name)
                                    .fontPoppins(size: 20, weight: .regular, color: .black)
                                    .padding(.vertical, 20)
                                
                                LazyVGrid(columns: columns, spacing: 3) {
                                    ForEach(month.days) { day in
                                        dayCell(for: day)
                                    }
                                }
                                .padding(.horizontal, 8)
                            }
                            .id(month.id)
                            //.background(.yellow)
                        }
                    }
                    .padding(.bottom, 20)
                    .background(Color.init(hex: "#FAFAFA"))
                }
                .opacity(isReady ? 1 : 0) // Scroll hone se pehle screen blank/hidden rahegi
                .onAppear {
                    DispatchQueue.main.async {
                        if viewModel.activeTab == .return {
                            proxy.scrollTo(viewModel.targetMonthId, anchor: .top)
                        } else {
                            proxy.scrollTo(viewModel.monthID(for: Date()), anchor: .top)
                        }
                        isReady = true
                    }
                    
                }
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private func headerView() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                
                // MARK: - Departure Tab (Left Portion)
                let isDepActive = (viewModel.activeTab == .departure) || (viewModel.activeTab == .multicity)
                
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.activeTab = .departure
                    }
                } label: {
                    VStack(spacing: 2) {
                        Text(viewModel.departureDt)
                            .fontLato(size: 18, weight: .black, color: .white)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.vertical, 12)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: 4)
                            .padding(.trailing, 8) // Divider se clean gap
                            .opacity(isDepActive ? 1 : 0)
                    }
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
                
                // MARK: - Vertical Divider (Always Visible)
                Rectangle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 1.5, height: 26)
                
                // MARK: - Return Tab (Right Portion)
                let isReturnActive = (viewModel.activeTab == .return)
                let isRoundtrip = (viewModel.tripType == .roundtrip)
                
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        viewModel.activeTab = .return
                    }
                } label: {
                    VStack(spacing: 2) {
                        if viewModel.returnDate != nil {
                            Text(viewModel.returnDt)
                                .fontLato(size: 18, weight: .black, color: .white)
                        } else {
                            Text("Return")
                                .fontLato(size: 16, weight: .bold, color: .white)
                            Text("Book return to save more")
                                .fontLato(size: 11, weight: .medium, color: .white.opacity(0.85))
                                .lineLimit(1)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.vertical, 12)
                    .opacity(isRoundtrip ? 1:0)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .fill(Color.white)
                            .frame(height: 4)
                            .padding(.leading, 8) // Divider se clean gap
                            .opacity(isReturnActive ? 1 : 0)
                    }
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
            }
            .frame(height: 60)
        }
        .background(Color(hex: "#57B4C7"))//.blue)
    }

    // Single Day Cell
    @ViewBuilder
    private func dayCell(for day: CalendarDay) -> some View {
        if let date = day.date {
            let currentDay = viewModel.calendar.startOfDay(for: date)
            let today = viewModel.calendar.startOfDay(for: Date())
            
            // Minimum allowed date
            let minAllowedDate: Date = {
                if (viewModel.activeTab == .return) || (viewModel.activeTab == .multicity), let dep = viewModel.departureDate {
                    return viewModel.calendar.startOfDay(for: dep)
                }
                return today
            }()
            
            let isDisabled = currentDay < minAllowedDate
            let isDep = viewModel.departureDate.map { viewModel.calendar.isDate($0, inSameDayAs: currentDay) } ?? false
            let isRet = viewModel.returnDate.map { viewModel.calendar.isDate($0, inSameDayAs: currentDay) } ?? false
            
            let isSelected: Bool = {
                switch viewModel.activeTab {
                case .departure, .multicity:
                    return isDep
                case .return:
                    if viewModel.returnDate != nil {
                        return isRet
                    } else {
                        return isDep
                    }
                }
            }()
            
            Button {
                handleDateTap(date)
            } label: {
                ZStack {
                    // Card Tile Background (Selected vs Normal)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(isSelected ? themeBlue : Color.white)
                    
                    Text(day.dayNumber)
                        .fontLato(
                            size: 18,
                            weight: .regular,
                            color: isSelected
                                ? .white
                                : (isDisabled ? Color.init(hex: "#c9c7c7") : .black)
                        )
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit) // Dynamic width ke hisaab se height auto-adjust hogi
            }
            .disabled(isDisabled)
            .buttonStyle(.plain)
        } else {
            // Khali date slot (Trailing/Leading Ghost Tile)
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white.opacity(0.6))
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
        }
    }
    
    private func handleDateTap(_ date: Date) {
        
        let tappedDay = viewModel.calendar.startOfDay(for: date)
        let isReturnTab = (viewModel.activeTab == .return)
        
        if isReturnTab {
//            if let dep = viewModel.departureDate {
//                let depDay = viewModel.calendar.startOfDay(for: dep)
//                onConfirm(dep, date)
//            }
            onConfirm(viewModel.departureDate ?? Date(), date)

        } else{
            var updatedReturnDate = viewModel.returnDate
            if let presentRetDt = viewModel.returnDate {
                let returnDay = viewModel.calendar.startOfDay(for: presentRetDt)
                if returnDay < tappedDay {
                    updatedReturnDate = tappedDay.addingDays(2)
                }
                
            }
            onConfirm(date, updatedReturnDate)
        }
    }
    
    private func scrollToRelevantMonth(proxy: ScrollViewProxy) {
        // UI layout render hone ke baad smooth scroll karne ke liye slight delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        
            if viewModel.activeTab == .return {
                // Case 1: Return ke case me selected departure month center me aayega
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(viewModel.targetMonthId, anchor: .top)
                }
            } else {
                // Case 2: Departure ke case me current month (aaj ki date) front/top pe dikhega
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(Date().toString(), anchor: .top)
                }
            }
        }
    }
}
