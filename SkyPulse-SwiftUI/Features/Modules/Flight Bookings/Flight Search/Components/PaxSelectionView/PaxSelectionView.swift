//
//  PaxSelectionView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 12/11/26.
//

import Foundation
import SwiftUI


struct PaxSelectionView: View {

    @ObservedObject var viewModel: FlightSearchViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var adults: Int
    @State private var childs: Int
    @State private var infants: Int
    var onSelect: (Int, Int, Int) -> Void
    
    init(viewModel: FlightSearchViewModel, onSelect: @escaping (Int, Int, Int) -> Void) {
        self.viewModel = viewModel
        _adults = State(initialValue: viewModel.request.adults)
        _childs = State(initialValue: viewModel.request.childs)
        _infants = State(initialValue: viewModel.request.infants)
        self.onSelect = onSelect
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 25) {
            
            headerView

            PaxCounterView(
                title: "Adults",
                subtitle: "12+ yrs",
                range: 1...9,
                selection: $adults
            )

            PaxCounterView(
                title: "Children",
                subtitle: "2-12 yrs",
                range: 0...8,
                selection: $childs
            )
            .padding(.top, 16)

            PaxCounterView(
                title: "Infants",
                subtitle: "0-2 yrs",
                range: 0...adults,
                selection: $infants
            )
            .padding(.top, 16)

            BottomMailToInfo()
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
        .background(Color.white)
    }
    
    @ViewBuilder
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Add Travellers")
                    .fontLato(size: 20, weight: .regular, color: .black)
                Spacer()
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        onSelect(adults, childs, infants)
                    }
                } label: {
                    Text("Done")
                        .fontLato(size: 22, weight: .regular, color: .themeColor)
                }
                .buttonStyle(.plain)
                .contentShape(Capsule())
            }
            .padding(.top, 20)

            Rectangle()
                .fill(.dividerColor)
                .frame(height: 1)
        }
    }
}


struct PaxCounterView: View {
    
    let title: String
    let subtitle: String
    let range: ClosedRange<Int>
    
    @Binding var selection: Int
    
    private var canDecrement: Bool { selection > range.lowerBound }
    private var canIncrement: Bool { selection < range.upperBound }
    
    var body: some View {
        HStack {
            // Left Side: Title & Subtitle (Same as before)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .fontLato(size: 18, weight: .black, color: .black)
                
                Text(subtitle)
                    .fontLato(size: 14, weight: .regular, color: .black.opacity(0.65))
            }
            
            Spacer()
            
            // Right Side: Rounded Stepper (- 1 +)
            HStack(spacing: 0) {
                // Minus Button
                Button {
                    if canDecrement {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selection -= 1
                        }
                    }
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(canDecrement ? .black.opacity(0.8) : .gray.opacity(0.35))
                        .frame(width: 40, height: 38)
                        .contentShape(Rectangle())
                }
                .disabled(!canDecrement)
                .buttonStyle(.plain)
                
                // Current Count
                Text("\(selection)")
                    .fontLato(size: 18, weight: .black, color: .black)
                    .frame(minWidth: 28)
                    .multilineTextAlignment(.center)
                    .monospacedDigit()
                
                // Plus Button
                Button {
                    if canIncrement {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selection += 1
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(canIncrement ? .black.opacity(0.8) : .gray.opacity(0.35))
                        .frame(width: 40, height: 38)
                        .contentShape(Rectangle())
                }
                .disabled(!canIncrement)
                .buttonStyle(.plain)
            }
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.init(hex: "#ccc"), lineWidth: 1.2)
            )
        }
    }
}


struct BottomMailToInfo: View {
    
    private let lightBg = Color(hex: "#F2F5FE")
    
    // Markdown link: Sirf email wala portion clickable link banega
    private let infoText: LocalizedStringKey = "For 10 passengers or above, kindly send the email on [groups@skypulse.com](mailto:groups@skypulse.com?subject=Group%20Booking%20Query)"
    
    var body: some View {
        Text(infoText)
            .fontLato(size: 15, weight: .black, color: .black.opacity(0.85))
            .tint(.themeColor) // Sirf clickable link (email) ka color blue hoga
            .multilineTextAlignment(.leading)
            .lineSpacing(3)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(lightBg)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(.themeColor, lineWidth: 1)
            )
        
        // Tap interceptor: Link open hone ko force handle karega
            .environment(\.openURL, OpenURLAction { url in
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                    return .handled
                } else {
                    // Simulator fallback check
                    print("⚠️ Cannot open URL (Simulator may lack Mail app): \(url)")
                    return .discarded
                }
            })
    }
}
