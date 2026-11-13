//
//  CabinSelectionView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 12/11/26.
//

import Foundation
import SwiftUI

struct CabinSelectionView: View {
    
    @ObservedObject var viewModel: FlightSearchViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCabin: CabinType
    var onSelect: (CabinType?) -> Void

    init(viewModel: FlightSearchViewModel, onSelect: @escaping (CabinType?) -> Void) {
        self.viewModel = viewModel
        self.onSelect = onSelect
        _selectedCabin = State(initialValue: viewModel.request.cabin)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            cabinOptions
            Spacer()
            doneButtonView
        }
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
        .background(Color.white)
    }
    
    private var headerView: some View {
        HStack {
            Text("Select Class")
                .fontLato(size: 20, weight: .regular, color: .black)
            Spacer()
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    onSelect(nil)
                }
            } label: {
                Image(systemName: "xmark")
                    .fontLato(size: 19, weight: .bold, color: .gray)
            }
            .buttonStyle(.plain)
            .contentShape(Capsule())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .background(
            Color.white
                //.shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 3)
        )
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.dividerColor)
                .frame(height: 1)
                .padding(.horizontal, 16)
        }
    }
    
    private var cabinOptions: some View {
        
        VStack(spacing: 20) {
            ForEach(CabinType.allCases, id: \.self) { cabin in
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        selectedCabin = cabin
                    }
                } label: {
                    HStack(spacing: 10) {
                        RadioButtonView(isSelected: (selectedCabin == cabin), size: 26, activeColor: .themeColor)
                        Text(cabin.rawValue)
                            .fontLato(size: 20, weight:.regular, color: .black)
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
                .contentShape(Capsule())
            }
        }
        .padding()
    }
    
    private var doneButtonView: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.25)) {
                onSelect(selectedCabin)
            }
        } label: {
            Text("DONE")
                .fontLato(size: 17, weight: .bold, color: .white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(
                    Capsule()
                        .fill(.themeColor)
                )
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 15)
    }
}
