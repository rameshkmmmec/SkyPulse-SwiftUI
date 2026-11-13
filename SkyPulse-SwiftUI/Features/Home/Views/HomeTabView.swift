//
//  HomeTabView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 05/11/26.
//

import SwiftUI

struct HomeTabView: View {
    
    @StateObject var viewModel: HomeViewModel
    @Namespace private var animationNamespace
    
    var body: some View {

        HStack() {
            ForEach(HomeTab.allCases, id: \.self) { tab in
                tabView(item: tab, isSelecetd: (viewModel.selectedTab == tab))
                
                // Last item ke baad Spacer na aaye
                if tab != HomeTab.allCases.last {
                    Spacer(minLength: 0)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(Color(hex: "#F1F8FE"))
        )
        .overlay{
            Capsule()
                .stroke(.themeColor, lineWidth: 1)
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func tabView(item: HomeTab, isSelecetd: Bool) -> some View {
        
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                viewModel.selectedTab = item
            }
        } label: {
            
            HStack(spacing: 4){
                Image(systemName: item.image)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(isSelecetd ? .white:.black)
                
                if isSelecetd {
                    Text(item.rawValue)
                        .fontPoppins(size: 15, weight: .semibold, color: .white)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                }

            }
            .padding(8)
            .background(
                Capsule()
                    .fill(isSelecetd ? .themeColor : .clear)
                    //.fill(isSelecetd ? .blue:.clear)
                    //.matchedGeometryEffect(id: "highlight", in: animationNamespace)
            )
            .padding(8)
        }
        .contentShape(Rectangle())
        .buttonStyle(.plain)
        .layoutPriority(isSelecetd ? 1:0)
    }
}
