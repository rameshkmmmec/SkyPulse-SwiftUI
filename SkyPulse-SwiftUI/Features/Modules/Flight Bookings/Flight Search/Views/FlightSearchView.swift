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
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
    
    private func tripSelectionView() -> some View {
         
        HStack() {
            ForEach(viewModel.trips) { type in
                let isSelected = (type == viewModel.tripType)
                
                Text(type.rawValue)
                    .fontPoppins(size: 12, weight: .regular, color: isSelected ? .white : .black.opacity(0.65))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(isSelected ? Color(hex: "#4791E8") : Color.clear)
                    .cornerRadius(12)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.tripType = type
                        }
                    }
            }
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
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
