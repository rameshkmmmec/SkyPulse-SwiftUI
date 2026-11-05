//
//  HomeMenuView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 05/11/26.
//

import SwiftUI

struct SideMenuView: View {
    
    @StateObject var viewModel: HomeViewModel
    @Binding var isSideMenu: Bool
    
    
    var body: some View {
                
        ZStack(alignment: .leading){
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                  
                    // User Profile Header (Safe Area ke niche)
                    if let user = viewModel.dashboardData?.sidemenu.userProfile {
                        HStack(spacing: 12) {
                            CachedAsyncImage(url: user.avatarURL, contentMode: .fill)
                                .frame(width: 54, height: 54)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(user.name)
                                    .fontPoppins(size: 20, weight: .bold, color: .black)
                                Text(user.subtitle)
                                    .fontPoppins(size: 15, weight: .regular, color: .gray)
                            }
                        }
                        .padding(.bottom, 8)
                        
                        Divider()
                    }

                    
                    if let sideMenu = viewModel.dashboardData?.sidemenu {
                        LazyVStack(spacing: 25){
                            ForEach(sideMenu.menuSections) { menu in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(menu.sectionTitle)
                                        .fontPoppins(size: 16, weight: .semibold, color: .black)
                                    
                                    menuSectionView(menuSection: menu)
                                }
                                
                            }
                        }
                        
                        
                        Text(sideMenu.footer.appVersion)
                            .fontPoppins(size: 14, weight: .regular, color: .blue)
                            .frame(maxWidth: .infinity, alignment: .center)

                    }
                }
                .background(.white)
                .padding(.horizontal, 16)
                .padding(.top, 56)
                .padding(.bottom, 34)
                
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 0.3), value: isSideMenu)
    }
    
    @ViewBuilder
    private func menuSectionView(menuSection: MenuSection) -> some View {
        
        VStack(alignment: .leading, spacing: 10) {
            ForEach(menuSection.items) { item in
                menuItemView(item: item)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.white)
        )
        .overlay {
            RoundedRectangle(cornerRadius:12, style: .continuous)
                .stroke(.gray.opacity(0.35), lineWidth: 1)
        }
    }
    
    @ViewBuilder
    private func menuItemView(item: MenuItem) -> some View {
        
        HStack(spacing: 5) {
            Image(systemName: item.icon)
                .fontPoppins(size: 18, weight: .regular, color: .black)
            
            Text(item.title)
                .fontPoppins(size: 18, weight: .regular, color: .black)
            
            Spacer()
        }
        .padding(8)
        .frame(maxWidth: .infinity)
    }
}

//struct SideMenuView: View {
//    @ObservedObject var viewModel: HomeViewModel  // Child view mein @ObservedObject use karein
//    @Binding var isSideMenu: Bool
//    
//    var body: some View {
//        ZStack(alignment: .leading) {
//            
//            // 1. Drawer Panel
//            ScrollView(showsIndicators: false) {
//                VStack(alignment: .leading, spacing: 18) {
//                    
//                    // User Profile Header (Safe Area ke niche)
//                    if let user = viewModel.dashboardData?.sidemenu.userProfile {
//                        HStack(spacing: 12) {
//                            CachedAsyncImage(url: user.avatarURL, contentMode: .fill)
//                                .frame(width: 48, height: 48)
//                                .clipShape(Circle())
//                            
//                            VStack(alignment: .leading, spacing: 2) {
//                                Text(user.name)
//                                    .fontPoppins(size: 16, weight: .bold, color: .black)
//                                Text(user.subtitle)
//                                    .fontPoppins(size: 13, weight: .regular, color: .gray)
//                            }
//                        }
//                        .padding(.bottom, 8)
//                        
//                        Divider()
//                    }
//                    
//                    // Menu Sections
//                    if let sideMenu = viewModel.dashboardData?.sidemenu {
//                        LazyVStack(alignment: .leading, spacing: 20) {
//                            ForEach(sideMenu.menuSections) { menu in
//                                VStack(alignment: .leading, spacing: 8) {
//                                    Text(menu.sectionTitle.uppercased())
//                                        .fontPoppins(size: 12, weight: .semibold, color: .gray)
//                                    
//                                    menuSectionView(menuSection: menu)
//                                }
//                            }
//                        }
//                    }
//                }
//                .padding(.horizontal, 16)
//                .padding(.top, 56) // <-- Top status bar / Notch ke liye safe space
//                .padding(.bottom, 34) // Bottom home indicator ke liye safe space
//            }
//            .frame(width: UIScreen.main.bounds.width * 0.78) // Drawer width 78%
//            .background(Color.white) // Poora white background drawer width ke andar
//            .ignoresSafeArea()       // Background safe area tak extend hoga, par content padding se safe rahega
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
//    }
//}
