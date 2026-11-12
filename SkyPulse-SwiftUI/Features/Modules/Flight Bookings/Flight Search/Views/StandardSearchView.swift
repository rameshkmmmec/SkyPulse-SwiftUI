//
//  StandardSearchView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 10/11/26.
//

import SwiftUI

struct StandardSearchView: View {
    
    @ObservedObject var viewModel: FlightSearchViewModel

    var body: some View {
    
        VStack(alignment: .leading, spacing: 10) {
            
            citysectionView
            
            travelDateView
            
            travelClassWithPassenges
            
            searchflightView {
                
            }
            .padding(.top, 20)
        }
        .frame(maxWidth: .infinity)
    }
    
    // 1. Travel Sector View
    @ViewBuilder
    private var citysectionView: some View {
        
        ZStack(alignment: .center) {
            HStack(alignment: .top, spacing: 12) {
                flightCityView(boundType: .outbound){
                    viewModel.activeSheet = .sourcCity
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                flightCityView(boundType: .inbound){
                    viewModel.activeSheet = .destCity
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            }
            .fixedSize(horizontal: false, vertical: true)

            switchCityView {
                viewModel.swapCity()
            }
        }
    }
    
    
    @ViewBuilder
    private func flightCityView(boundType: BoundType, selectCity: @escaping (()-> Void) ) -> some View {
        
        let tuples = viewModel.cityTuple(bType: boundType)
        VStack(alignment: .leading, spacing: 0) {
            Text(tuples.0)
                .fontPoppins(size: 13, weight: .medium, color: Color(hex: "#747474"))
            
            Text(AttributedString.dualTextStyled(primary: StyledTextSegment(text: tuples.1, size: 18, font: .poppins, weight: .bold, color: .black), secondary: StyledTextSegment(text: " \(tuples.2)", size: 15, font: .poppins, weight: .regular, color: Color(hex: "#525252"))))
            
            Text(tuples.3)
                .fontPoppins(size: 12, weight: .regular, color: Color(hex: "#747474"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(2)
        }
        .padding(.leading, (boundType == .outbound) ? 10:20)
        .padding([.vertical, .trailing], 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .cardShape(cornerRadius: 8, fillColor: Color(hex: "#F7F7F7"), borderColor: Color(hex: "#E7E7E7"))
        .contentShape(Rectangle())
        .onTapGesture {
            selectCity()
        }
    }
    
    // 2. Switch Sector View
    @ViewBuilder
    private func switchCityView(switchAction: @escaping () -> Void) -> some View {
        Button {
            switchAction()
        } label: {
            VStack(){
                Image("ic_switch")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .fontPoppins(size: 15, weight: .semibold, color: .blue)
                    .frame(width: 26, height: 23)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 5)
            }
            .cardShape(cornerRadius: 6, borderColor: Color(hex: "#E7E7E7"))
        }
    }
    
    // 3. Travel Date View
    @ViewBuilder
    private var travelDateView : some View {
        
        HStack(alignment: .top, spacing: 12) {
            
            flightDateView(boundType: .outbound){
                viewModel.activeSheet = .departureDt
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            flightDateView(boundType: .inbound){
                viewModel.tripType = .roundtrip
                viewModel.activeSheet = .arrivalDt
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    @ViewBuilder
    private func flightDateView(boundType: BoundType, selectDate: @escaping (()-> Void)) -> some View {
        
        let tuples = viewModel.travelDateTuples(bType: boundType)
        let isBlank = (tuples.2 == "")
        
        VStack(alignment: .leading, spacing: 0) {
            
            Text(tuples.0)
                .fontPoppins(size: 13, weight: .medium, color: Color(hex: isBlank ? "#3D8AF7":"#747474"))
            
            if isBlank {
                Text(tuples.1)
                    .fontPoppins(size: 12, weight: .regular, color: Color(hex: "#367C7C"))
                    .frame(maxWidth: .infinity, alignment: .leading)

            } else {
                HStack(alignment: .bottom,spacing: 4){
                    Text(tuples.1)
                        .fontPoppins(size: 17, weight: .bold, color: .black)
                    Text(tuples.2)
                        .fontPoppins(size: 15, weight: .regular, color: Color(hex: "#525252"))
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .cardShape(cornerRadius: 8, fillColor: Color(hex: "#F7F7F7"), borderColor: Color(hex: "#E7E7E7"))
        .contentShape(Rectangle())
        .onTapGesture {
            selectDate()
        }
    }

    
    // 4. Travel Passenges & Travel Class
    @ViewBuilder
    private var travelClassWithPassenges: some View {
        
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
            
            Text((vType == .travelPax) ? viewModel.request.tPaxText : viewModel.request.cabin.rawValue)
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
    
    // 5. Search flight button
    @ViewBuilder
    private func searchflightView(searchAction: @escaping (()->Void)) -> some View {
        
        Button {
            searchAction()
        } label: {
            Text("SEARCH FLIGHTS")
                .fontPoppins(size: 18, weight: .semibold, color: .white)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background {
                    Capsule()
                        .fill(Color(hex: "#57B4C7"))
                }
        }
        .contentShape(Rectangle())
        .buttonStyle(.plain)
    }
}
