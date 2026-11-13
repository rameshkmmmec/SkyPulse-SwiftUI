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
            
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    
                    BackButtonView(title: "Book Flights") {
                        dismiss()
                    }
                    
                    tripSelectionView()
                    
                    if viewModel.tripType == .multicity {
                        MultiCitySearchView(viewModel: viewModel, scrollProxy: proxy)
                    } else {
                        StandardSearchView(viewModel: viewModel)
                    }
                    
                    Spacer()
                }
            }
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
                
            // 2. departure & arrival date selection
            case .departureDt, .arrivalDt:
                SkyPulseCalendarView(minimumDate:viewModel.minDate, departureDate: viewModel.request.departureDate.toDate(), returnDate: viewModel.request.returnDate?.toDate(), startTab: viewModel.calendarTab, tripType: viewModel.tripType){ Dep, Ret in
                    viewModel.updateJourneyDates(dep: Dep, ret: Ret)
                    viewModel.activeSheet = nil
                }
                
            // 3. travel pax selection
            case .travelPax:
                PaxSelectionView(viewModel: viewModel) { adt, chd, inf in
                    viewModel.updatePax(adt: adt, chd: chd, inf: inf)
                }
                
            // 4. travel class selection
            case .travelClass:
                CabinSelectionView(viewModel: viewModel) { cabinType in
                    if let cabin = cabinType {
                        viewModel.request.cabin = cabin
                    }
                    viewModel.activeSheet = nil
                }
                
            // 5. multicity source & destination selection
            case .sourceCity(let index), .destinationCity(index: let index):
                let boundType: BoundType = (viewModel.activeSheet == .sourceCity(index: index)) ? .outbound:.inbound
                CityAutoSuggestView(source: viewModel.request.sourceModel, dest: viewModel.request.destModel, boundType: boundType) { city, boundType in
                    if boundType == .outbound {
                        viewModel.request.multiSectors[index].source = city
                    }else {
                        viewModel.request.multiSectors[index].dest = city
                    }
                    viewModel.activeSheet = nil
                }
                
            // 6. multicity departure date selection
            case .departureDate(let index):
                let departureDate = viewModel.getMinimumDepartureDate(for: index)
                let minDate = (index == 0) ? Date() : departureDate.toDate() ?? Date()
                SkyPulseCalendarView(minimumDate:minDate, departureDate: departureDate.toDate(), returnDate: viewModel.request.returnDate?.toDate(), startTab: .multicity, tripType: viewModel.tripType){ Dep, Ret in
                    viewModel.updateMultiCityDepartureDate(for: index, newDate: Dep)
                    viewModel.activeSheet = nil
                }
            }
        }
        
        .displayToast(item: $viewModel.activeToast)
        
        .navigationDestination(isPresented: $viewModel.shouldProceed) {
            
            if viewModel.tripType == .multicity {
                MultiCityFlightListingView(vm: viewModel)
            } else {
                if viewModel.tripType == .oneway {
                    FlightListingView(vm: viewModel)
                } else {
                    if viewModel.isDomestic {
                        RTFlightListingView(vm: viewModel)
                    } else {
                        IntlRTFlightListingView(vm: viewModel)
                    }
                }
            }
        }
        
//        .displayToast(isPresented: $viewModel.activeAlert, message: viewModel.eMessage, bottomPadding: 130, imgName: "info.circle", imgColor: .white, vSpace:12)

        
    }
    
    private func tripSelectionView() -> some View {
         
        HStack() {
            ForEach(viewModel.trips) { type in
                let isSelected = (type == viewModel.tripType)
                
                Text(type.rawValue)
                    .fontPoppins(size: isSelected ? 14:13, weight: isSelected ? .medium:.regular, color: Color(hex: isSelected ? "#57B4C7":"#4A4A4A"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .cardShape(borderColor: isSelected ? .themeColor:.clear, lineWidth: 2, cardType: .capsule)
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


struct TravelClassWithPaxView:  View {
    
    @ObservedObject var viewModel: FlightSearchViewModel

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            viewTypeSection(vType: .travelPax){
                viewModel.activeSheet = .travelPax
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            viewTypeSection(vType: .travelClass){
                viewModel.activeSheet = .travelClass
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    @ViewBuilder
    private func viewTypeSection(vType: ViewType, onSelect: @escaping (()->Void)) -> some View {
        
        VStack(alignment: .leading, spacing: 0) {
            Text((vType == .travelPax) ? "TRAVELLER" : "TRAVEL CLASS")
                .fontPoppins(size: 13, weight: .medium, color: Color(hex: "#747474"))
            
            Text((vType == .travelPax) ? viewModel.travellers : viewModel.request.cabin.rawValue)
                .fontPoppins(size: 15, weight: .medium, color: .black)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .cardShape(cornerRadius: 8, fillColor: Color(hex: "#F7F7F7"), borderColor: Color(hex: "#E7E7E7"))
        .contentShape(Rectangle())
        .onTapGesture {
            onSelect()
        }
    }
}


struct SearchButtonView: View {
    
    var searchAction: (()->Void)
    var body: some View {
        
        Button {
            searchAction()
        } label: {
            Text("SEARCH FLIGHTS")
                .fontPoppins(size: 18, weight: .semibold, color: .white)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(LinearGradient.themeGradient)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .contentShape(Rectangle())
        .buttonStyle(.plain)
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
