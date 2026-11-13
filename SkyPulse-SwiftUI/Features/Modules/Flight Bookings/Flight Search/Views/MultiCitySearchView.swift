//
//  MultiCitySearchView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 10/11/26.
//

import SwiftUI

struct MultiCitySearchView: View {
    
    @ObservedObject var viewModel: FlightSearchViewModel
    var scrollProxy: ScrollViewProxy? = nil

    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            Spacer().frame(height: 1)

            ForEach(viewModel.request.multiSectors.indices, id: \.self) { index in
                if viewModel.request.multiSectors.indices.contains(index) {
                    
                    MultiCityLegCardView(sector: viewModel.request.multiSectors[index], index: index, vm: viewModel, scrollProxy: scrollProxy) { boundType in
                        if boundType == .outbound {
                            viewModel.activeSheet = .sourceCity(index: index)
                        } else {
                            viewModel.activeSheet = .destinationCity(index: index)
                        }
                    } selectDate: {
                        viewModel.activeSheet = .departureDate(index: index)
                    }
                    .id("sector_\(index)")
                }
            }
            
            TravelClassWithPaxView(viewModel: viewModel)
            
            SearchButtonView {
                let validation = viewModel.validateMultiCitySectors()
                
                withAnimation(.easeInOut(duration: 0.3)) {
                    if validation.isValid {
                        viewModel.activeToast = nil
                        viewModel.shouldProceed = true
                        
                    }else {
                        viewModel.shouldProceed = false
                        if let errorMessage = validation.message {
                            if let targetIndex = validation.invalidIndex {
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    scrollProxy?.scrollTo("sector_\(targetIndex)", anchor: .top)
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                viewModel.activeToast = .error(errorMessage)
                            }
                        }
                    }
                }
            }
            .padding(.top, 20)
            
        }
        .frame(maxWidth: .infinity)
    }
}


struct MultiCityLegCardView: View {
    
    let sector: MultiCityLeg
    let index: Int
    @StateObject var vm: FlightSearchViewModel
    let scrollProxy: ScrollViewProxy?

    var selectCity: (BoundType)->Void
    let selectDate: (()->Void)

    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            
            LegIndex(index: index)
            
            LegCardView(city: sector.source) {
                selectCity(.outbound)
            }
            
            LegCardView(city: sector.dest, boundType: .inbound) {
                selectCity(.inbound)
            }
            
            DateCardView(departureDate: sector.departureDate) {
                selectDate()
            }
            
            addRemoveView()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .cardShape(cornerRadius: 8, borderColor: .themeColor, lineWidth: 0.7)
    }
    
    @ViewBuilder
    private func LegCardView(city: CityModel?, boundType: BoundType = .outbound, selectCity: @escaping (()-> Void)) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            
            Text(boundType == .outbound ? "Departure From":"Arrival At")
                .fontPoppins(size: 13, weight: .medium, color: Color(hex: "#747474"))
            
            if city != nil {
                Text(AttributedString.dualTextStyled(primary: StyledTextSegment(text: city?.cityName ?? "", size: 18, font: .poppins, weight: .semibold, color: .black), secondary: StyledTextSegment(text: " \(city?.code ?? "")", size: 18, font: .poppins, weight: .medium, color: Color(hex: "#525252"))))
            } else {
                Text(boundType == .outbound ? "Select Departure City" : "Select Arrival City")
                    .fontPoppins(size: 18, weight: .semibold, color: Color(hex: "#747474"))
            }
            Rectangle()
                .fill(.dividerColor)
                .frame(height: 0.8)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            selectCity()
        }
    }
    
    @ViewBuilder
    private func DateCardView(departureDate: String?, selectDate: @escaping (()-> Void)) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Departure Date")
                .fontPoppins(size: 13, weight: .medium, color: Color(hex: "#747474"))
            Text(departureDate ?? "Select Date")
                .fontPoppins(size: 18, weight: (departureDate != nil) ? .bold:.semibold, color: (departureDate != nil) ? .black : Color(hex: "#747474"))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            selectDate()
        }
    }
    
    @ViewBuilder
    private func LegIndex(index: Int) -> some View {
        HStack(alignment: .center) {
            Text("\(sector.title) \(index+1)")
                .fontLato(size: 14, weight: .bold, color: .black)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(
            Capsule()
                .fill(Color(hex: "#2093EF").opacity(0.12))
        )
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    private func addRemoveView() -> some View {
        // 4. Add & Remove button
        let totalSectors = vm.request.multiSectors.count
        let isLastSector = (index == totalSectors - 1)
        
        let isAddVisible = (index >= 1) && isLastSector && (totalSectors < 6)
        let isDeleteVisible = (index >= 2) && isLastSector
        
        if isAddVisible || isDeleteVisible {
            HStack(alignment: .center, spacing: 10) {
                Spacer()
                if isAddVisible {
                    buttonWithType(text: "+ ADD CITY", color: Color.init(hex: "#2093EF")) {
                        
                        let newIndex = index + 1
                        vm.request.addSectors(at: newIndex)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                scrollProxy?.scrollTo("sector_\(newIndex)", anchor: .bottom)
                            }
                        }
                    }
                }
                if isDeleteVisible {
                    buttonWithType(text: "- REMOVE", color: Color.init(hex: "#ABABAB")) {
                        
                        //vm.request.removeSector(from: index)
                        let prevIndex = max(0, index - 1)
                        withAnimation(.easeInOut(duration: 0.3)) {
                            vm.request.removeSector(from: index)
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                scrollProxy?.scrollTo("sector_\(prevIndex)", anchor: .top)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
    }
    
    @ViewBuilder
    private func buttonWithType(text: String, color:Color, action: @escaping ()-> Void)-> some View {
        Button {
            action()
        } label: {
            Text(text)
                .fontLato(size: 15, weight: .regular, color: color)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.white)
                .overlay(
                    Capsule()
                        .stroke(color, lineWidth: 1)
                )
        }
        .contentShape(Capsule())
        .buttonStyle(.plain)
    }
}
