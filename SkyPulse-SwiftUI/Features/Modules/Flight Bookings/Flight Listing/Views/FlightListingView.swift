//
//  FlightListingView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 13/11/26.
//

import SwiftUI

struct FlightListingView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: FlightListViewModel
    
    init(vm: FlightSearchViewModel) {
        _viewModel = StateObject(wrappedValue: FlightListViewModel(vm: vm))
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            FlightListNavHeaderView(vm: viewModel.vm) {
                dismiss()
            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}
