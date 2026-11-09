//
//  ModuleSearchView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 08/11/26.
//

import SwiftUI

struct ModuleSearchView: View {
    
    @StateObject private var viewModel: SearchViewModel
    @Environment(\.dismiss) private var dismiss
    

    init(vm: HomeViewModel, id: String) {
        _viewModel = StateObject(wrappedValue: SearchViewModel(viewModel: vm, mId: id))
    }

    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            Button {
                dismiss()
            } label: {
                HStack(spacing: 10){
                    Image(systemName: "arrow.left")
                        .fontPoppins(size: 20, weight: .bold, color: .black.opacity(0.75))
                    
                    Text(viewModel.mType.rawValue)
                        .fontPoppins(size: 20, weight: .semibold, color: .black.opacity(0.85))
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            ScrollView(.horizontal, showsIndicators: false){
                LazyHStack(spacing: 10) {
                    
                    ForEach(viewModel.modules) { module in
                        
                        VStack(spacing: 2){
                            Image(systemName: module.iconSystemName)
                                .fontPoppins(size: 20, weight: .bold, color: .black)
                            
                            Text(module.title)
                                .fontPoppins(size: 16, weight: .medium, color: .black.opacity(0.75))
                        }
                    }
                }
            }
            
            Spacer()
            
        }
        .navigationBarBackButtonHidden(true)
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
}
