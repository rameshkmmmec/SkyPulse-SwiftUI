//
//  MyTripsView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 05/11/26.
//

import Foundation
import SwiftUI

struct MyTripsView: View {
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            Text("MyTrip")
                .fontPoppins(size: 18, weight: .semibold, color: .black)
                .frame(maxWidth: .infinity, alignment: .center)

            Rectangle()
                .fill(.gray.opacity(0.25))
                .frame(height: 1)
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}
