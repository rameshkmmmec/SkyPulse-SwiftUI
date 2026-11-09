//
//  HotelSearchView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 10/11/26.
//

import SwiftUI

struct HotelSearchView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            BackButtonView(title: "Book Hotel") {
                dismiss()
            }
            
            Spacer()
            
        }
        .navigationBarBackButtonHidden(true)
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
}
