//
//  HomeView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 01/11/26.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var vm: HomeViewModel
    var onSelectMenu: (()->Void)
    var onSelectNotify: (()->Void)
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            homeTopView(onTapMenu: onSelectMenu, onTapNotif: onSelectNotify)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    
                    VStack(alignment: .leading, spacing: 0){
                        Text("Hello User")
                            .fontPoppins(size: 15, weight: .regular, color: .gray)
                        
                        Text(vm.dashboardData?.homePage.pageTitle ?? "")
                            .fontPoppins(size: 28, weight: .semibold, color: .black)
                    }
                    
                    if let homeData = vm.dashboardData?.homePage{
                        LazyVStack(spacing: 24){
                            ForEach(homeData.modules, id: \.id) { module in
                              
                                Text(module.title)
                                    .fontPoppins(size: 16, weight: .bold, color: .black.opacity(0.85))
                                
                                switch module.content {
                                case .bannerCard(let layout, let item):
                                    bannerCardView(layout: layout, item: item)
                                    
                                case .bannerCarousel(let layout, let items):
                                    bannarCorouselView(layout: layout, items: items)

                                case .gridActions(let layout, let items):
                                    gridActionsView(layout: layout, items: items)
                                    
                                case .horizontalCards(let layout, let items):
                                    horizontalCardsView(layout: layout, items: items)
                                    
                                case .unknown:
                                    EmptyView()
                                }
                                
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 90) // Floating tab bar ke liye bottom clearance
            }
            .background(.white)//Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        }
        .background(Color(hex: "#DCE7E7"))
    }
    
    
    @ViewBuilder
    private func homeTopView(onTapMenu: @escaping (() -> Void), onTapNotif: @escaping (() -> Void)) -> some View {
        HStack() {
            buttonWith(img: "line.3.horizontal") {
                onTapMenu()
            }
            Spacer()
            
            Text("SkyPulse")
                .fontLato(size: 20, weight: .bold, color: .black)
            
            Spacer()
            buttonWith(img: "bell") {
                onTapNotif()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.white)//Color(hex: "#DAF0EE"))
    }
    
    @ViewBuilder
    private func buttonWith(img: String, onTap: @escaping () -> Void) -> some View {
        
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                onTap()
            }
        } label: {
            Image(systemName: img)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.black)
                .contentShape(Rectangle())
        }
        .contentShape(Rectangle())
        .buttonStyle(.plain)
    }
    
    
    // homepage components
    @State private var currentBannerIndex: Int = 0

    @ViewBuilder
    private func bannarCorouselView(layout: CarouselLayout, items: [BannerItem]) -> some View {
        VStack(spacing: 12) {
            TabView(selection: $currentBannerIndex) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    ZStack(alignment: .bottomLeading) {
                        // 1. Remote Image Layer
                        RemoteImageView(url: item.imageURL)
                        
                        // 2. Gradient Layer
                        LinearGradient(
                            colors: [.clear, Color.black.opacity(0.4), Color.black.opacity(0.85)],
                            startPoint: .center,
                            endPoint: .bottom
                        )

                        // 3. Text Info Layer
                        VStack(alignment: .leading, spacing: 4) {
                            if let badge = item.badgeText {
                                Text(badge.uppercased())
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                            }
                            
                            Text(item.title)
                                .font(.headline)
                                .foregroundColor(.white)
                                .lineLimit(1)
                            
                            Text(item.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.85))
                                .lineLimit(1)
                        }
                        .padding(14)
                    }
                    // Card ka exact size define karein
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .clipShape(RoundedRectangle(cornerRadius: layout.cornerRadius, style: .continuous))
                    .padding(.horizontal, layout.paddingHorizontal) // Left aur Right margin barabar
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 180)

            // Custom Dots Indicator (Text ke upar overlap nahi hoga)
            if items.count > 1 {
                HStack(spacing: 6) {
                    ForEach(0..<items.count, id: \.self) { index in
                        Capsule()
                            .fill(currentBannerIndex == index ? Color.blue : Color.gray.opacity(0.35))
                            .frame(width: currentBannerIndex == index ? 16 : 6, height: 6)
                            .animation(.easeInOut(duration: 0.2), value: currentBannerIndex)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func bannerCardView(layout:BannerCardLayout, item:ReferralPromoData) -> some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Text(item.headline)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(item.description)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            
            Button(action: {
                print("CTA deepLink: \(item.ctaDeepLink)")
            }) {
                Text(item.ctaButtonText)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(hex: layout.accentColor))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .padding(.top, 4)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(hex: layout.backgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 16)
        
    }
    
    @ViewBuilder
    private func gridActionsView(layout:GridLayout, items:[QuickActionItem]) -> some View {
        
        var columns: [GridItem] {
            Array(repeating: GridItem(.flexible(), spacing: layout.itemSpacing), count: layout.columns)
        }
        
        LazyVGrid(columns: columns, spacing: layout.itemSpacing) {
            ForEach(items) { item in
                Button(action: {
                    print("Tapped: \(item.deepLink)")
                }) {
                    VStack(spacing: 8) {
                        ZStack(alignment: .topTrailing) {
                            Circle()
                                .fill(Color(hex: layout.cardBackground))
                                .frame(width: 54, height: 54)
                                .overlay(
                                    Image(systemName: item.iconSystemName)
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                )
                            
                            if let badge = item.badgeText {
                                Text(badge)
                                    .font(.system(size: 8, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2)
                                    .background(Color(hex: item.badgeBgColor ?? "#E53935"))
                                    .clipShape(Capsule())
                                    .offset(x: 6, y: -4)
                            }
                        }
                        
                        Text(item.title)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func horizontalCardsView(layout:CardListLayout, items:[DestinationCardItem]) -> some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 14) {
                ForEach(items) { item in
                    VStack(alignment: .leading, spacing: 6) {
                        AsyncImage(url: item.imageURL) { phase in
                            if let image = phase.image {
                                image.resizable().aspectRatio(contentMode: .fill)
                            } else {
                                Color.gray.opacity(0.2)
                            }
                        }
                        .frame(width: layout.cardWidth, height: 160)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: layout.cornerRadius))
                        
                        HStack {
                            Text(item.title)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Spacer()
                            Label(String(format: "%.1f", item.rating), systemImage: "star.fill")
                                .font(.caption2)
                                .foregroundColor(.orange)
                        }
                        
                        Text(item.subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(item.startingPrice)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    .frame(width: layout.cardWidth)
                }
            }
            .padding(.horizontal, 16)
        }
        
    }
}

