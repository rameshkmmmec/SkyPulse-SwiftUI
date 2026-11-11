//
//  CityAutoSuggestView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 11/11/26.
//

import Foundation
import SwiftUI

struct CityAutoSuggestView: View {
    
    @StateObject private var vm: CityViewModel
    let selectCity: (CityModel?, BoundType) -> Void
    @FocusState private var focusedField: BoundType?

    
    init(source: CityModel?, dest: CityModel?, boundType: BoundType, selectCity: @escaping (CityModel?, BoundType) -> Void) {
        _vm = StateObject(wrappedValue: CityViewModel(source: source, dest: dest, bType: boundType))
        self.selectCity = selectCity
    }

    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            ScrollView(showsIndicators: false) {
                
                searchContainerView(focusedField: focusedField)
                
                if vm.cities.count > 0 {
                    LazyVStack {
                        ForEach(vm.cities) { city in
                            configCell(city: city) {
                                selectCity(city, vm.boundType)
                            }
                        }
                    }
                }else {
                    VStack(alignment: .leading, spacing: 8) {
                        Rectangle()
                            .fill(.gray.opacity(0.25))
                            .frame(height: 1)
                        
                        Text("Search city not found, please try with another code")
                            .fontPoppins(size: 16, weight: .regular, color: .black.opacity(0.85))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

    }
    
    @ViewBuilder
    private func configCell(city: CityModel, onSelect: @escaping (()->Void)) -> some View {
        
        VStack(alignment: .leading, spacing: 1){
            HStack(spacing: 2){
                Text("\(city.code) - ")
                    .fontPoppins(size: 20, weight: .bold, color: .black)
                
                Text("\(city.cityName), ")
                    .fontPoppins(size: 18, weight: .medium, color: .black)

                Text(city.country)
                    .fontPoppins(size: 16, weight: .regular, color: .black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(city.airportName)
                .fontPoppins(size: 14, weight: .regular, color: .black.opacity(0.65))
            
            Rectangle()
                .fill(.gray.opacity(0.25))
                .frame(height: 1)
                .padding(.top, 8)
        }
        .padding(.leading, 5)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
            onSelect()
        }
        .padding(.horizontal, 16)
    }
    
    
    @ViewBuilder
    private func searchContainerView(focusedField: BoundType?) -> some View {
        
        VStack(alignment: .leading, spacing: 16) {

            FlightCityTfView(text: $vm.sourceText, city: vm.sourceModel?.cityName, title: "FROM", placeholder: AppConstant.kCitySearchPh, isReturn: false, isActive: (vm.boundType == .outbound), isFocused: $focusedField, targetType: .outbound, onTap: {
                switchActiveField(to: .outbound)

            }, img: "arrow.left") {
                selectCity(nil, vm.boundType)
            }
            
            FlightCityTfView(text: $vm.destText, city: vm.destModel?.cityName, title: "TO", placeholder: AppConstant.kCitySearchPh, isReturn: true, isActive: (vm.boundType == .inbound), isFocused: $focusedField, targetType: .inbound, onTap: {
                switchActiveField(to: .inbound)

            }, img: "airplane.arrival") {
                selectCity(nil, vm.boundType)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
    }
    
    private func switchActiveField(to type: BoundType) {
        vm.boundType = type
        focusedField = type
    }
}

struct FlightCityTfView: View {
    
    @Binding var text: String
    let city: String?
    let title: String
    let placeholder: String
    let isReturn: Bool
    let isActive: Bool // Highlight/Border ke liye (optional)
    var isFocused: FocusState<BoundType?>.Binding
    let targetType: BoundType
    let onTap: () -> Void
    let img: String
    let backAction: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .center, spacing: 14) {
                // Airplane Icon
                Button {
                    backAction()
                } label: {
                    Image(systemName: img)
                        .fontPoppins(size: 16, weight: .semibold, color: .black)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color(hex: "#61717D"))
                    
                    if isActive {
                        // Jab ACTIVE ho: Editable TextField + Keyboard focus
                        HStack {
                            TextField(placeholder, text: $text)
                                .focused(isFocused, equals: targetType)
                                .font(.system(size: 18, weight: text.isEmpty ? .regular : .bold))
                                .foregroundColor(.black)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.words)
                        }
                    } else {
                        // Jab INACTIVE ho: Already selected city ka naam ya placeholder
                        if let name = city, !name.trimmingCharacters(in: .whitespaces).isEmpty {
                            Text(name)
                                .fontPoppins(size: 19, weight: .bold, color: .black)
                        } else {
                            Text(placeholder)
                                .fontPoppins(size: 15, weight: .regular, color: Color(hex: "#7A8287"))
                        }
                    }
                }
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
//            .background(Color.white)
//            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
//            // Active box ke charo taraf subtle indicator/border (optional)
//            .overlay(
//                RoundedRectangle(cornerRadius: 6)
//                    .stroke(isActive ? Color.blue.opacity(0.6) : Color.clear, lineWidth: 1.5)
//            )
            .cardShape(cornerRadius: 6, borderColor: Color(hex: isActive ? "#57B4C7":"#ECECEC"), lineWidth: 1.5)
        }
        .buttonStyle(.plain)
    }

}
