//
//  FlightSearchView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 10/11/26.
//

import SwiftUI

struct FlightSearchView: View {
    
    @StateObject private var viewModel: FlightSearchViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(vm: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: FlightSearchViewModel(vm: vm))
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            BackButtonView(title: "Book Flights") {
                dismiss()
            }
            
            tripSelectionView()
            
            if viewModel.tripType == .multicity {
                MultiCitySearchView(viewModel: viewModel)
            } else {
                StandardSearchView(viewModel: viewModel)
            }
            
            Spacer()
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        
        .appBottomSheet(item: $viewModel.activeSheet, style: viewModel.sheetStyle) { activeSheet in
            
            switch activeSheet {
                
                // 1. source & destination city selection
            case .sourcCity, .destCity:
                let boundType: BoundType = (viewModel.activeSheet == .sourcCity) ? .outbound:.inbound
                CityAutoSuggestView(source: viewModel.request.sourceModel, dest: viewModel.request.destModel, boundType: boundType) { city, boundType in
                    viewModel.updateCityModel(city: city, boundType: boundType)
                }
                
            case .departureDt, .arrivalDt:
                SkyPulseCalendarView(minimumDate:viewModel.minDate, departureDate: viewModel.request.departureDate.toDate(), returnDate: viewModel.request.returnDate?.toDate(), startTab: viewModel.calendarTab, tripType: viewModel.tripType){ Dep, Ret in
                    viewModel.updateJourneyDates(dep: Dep, ret: Ret)
                    viewModel.activeSheet = nil
                }
                
            case .travelPax:
                PaxSelectionView(viewModel: viewModel) { adt, chd, inf in
                    viewModel.updatePax(adt: adt, chd: chd, inf: inf)
                }
            case .travelClass:
                CabinSelectionView(viewModel: viewModel) { cabinType in
                    if let cabin = cabinType {
                        viewModel.request.cabin = cabin
                    }
                    viewModel.activeSheet = nil
                }
                
                
            case .sourceCity(let index):
                
                let boundType: BoundType = (viewModel.activeSheet == .sourcCity) ? .outbound:.inbound
                CityAutoSuggestView(source: viewModel.request.sourceModel, dest: viewModel.request.destModel, boundType: boundType) { city, boundType in
                    viewModel.updateCityModel(city: city, boundType: boundType)
                }
                
            case .destinationCity(index: let index):
                
                let boundType: BoundType = (viewModel.activeSheet == .sourcCity) ? .outbound:.inbound
                CityAutoSuggestView(source: viewModel.request.sourceModel, dest: viewModel.request.destModel, boundType: boundType) { city, boundType in
                    viewModel.updateCityModel(city: city, boundType: boundType)
                }
                
            case .departureDate(let index):
                
                let boundType: BoundType = (viewModel.activeSheet == .sourcCity) ? .outbound:.inbound
                CityAutoSuggestView(source: viewModel.request.sourceModel, dest: viewModel.request.destModel, boundType: boundType) { city, boundType in
                    viewModel.updateCityModel(city: city, boundType: boundType)
                }
            }
        }
    }
    
    private func tripSelectionView() -> some View {
         
        HStack() {
            ForEach(viewModel.trips) { type in
                let isSelected = (type == viewModel.tripType)
                
                Text(type.rawValue)
                    .fontPoppins(size: isSelected ? 14:13, weight: isSelected ? .medium:.regular, color: Color(hex: isSelected ? "#57B4C7":"#4A4A4A"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .cardShape(borderColor: isSelected ? Color(hex: "#57B4C7"):.clear, lineWidth: 2, cardType: .capsule)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.tripType = type
                        }
                    }
            }
        }
        .cardShape(borderColor: Color(hex: "#EAEAEA"), cardType: .capsule)
    }
}

struct BackButtonView: View {
    
    let title: String
    var backAction: ()->Void
    
    var body: some View {
        
        Button {
            backAction()
        } label: {
            HStack(spacing: 10){
                Image(systemName: "arrow.left")
                    .fontPoppins(size: 20, weight: .semibold, color: .black.opacity(0.75))
                
                Text(title)
                    .fontPoppins(size: 18, weight: .medium, color: .black.opacity(0.85))
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
    }
}
