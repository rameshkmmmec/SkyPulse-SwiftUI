//
//  FlightListNavHeaderView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 13/11/26.
//

import SwiftUI

struct FlightListNavHeaderView: View {

    @ObservedObject var vm: FlightSearchViewModel
    var imgUrl: String?
    var isDivider: Bool = false
    var callback: () -> Void
    
    var body: some View {
        
        Button {
            callback()
        } label: {

            HStack(alignment: .top,spacing: 5) {
                Image(systemName: "arrow.left")
                    .fontLato(size: 15, weight: .bold, color: .black)
                VStack(alignment: .leading, spacing: 1) {
                    if let image = imgUrl {
                        HStack(spacing: 6) {
                            Text(vm.request.sourceModel.cityName)
                                .fontPoppins(size: 18, weight: .semibold, color: .black)
                            
                            RemoteImageView(url: URL(string: image))

                            Text(vm.request.destModel.cityName)
                                .fontPoppins(size: 18, weight: .semibold, color: .black)
                        }
                    }else {
                        Text(vm.cityInfo)
                            .fontPoppins(size: 18, weight: .semibold, color: .black)
                    }
                    Text(vm.detailInfo)
                        .fontPoppins(size: 13, weight: .regular, color: .black)
                }
                .padding(.leading, 5)
                .offset(y:-5)
                
                Spacer()
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .frame(maxWidth: .infinity)
            .background(.white)
            .shadow(
                color: Color.black.opacity(0.08), // Halka subtle shadow
                radius: 3,                        // Soft blur
                x: 0,                             // Horizontal bilkul zero
                y: 3                              // Niche ki taraf drop
            )
        }
        .contentShape(Rectangle())
        .buttonStyle(.plain)
    }
}
