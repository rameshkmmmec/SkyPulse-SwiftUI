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
    @Binding var showLogin: Bool
    @Binding var homePath: [HomeRoute]

    @Environment(AuthManager.self) private var auth
    
    var body: some View {
        
        let currentUser = self.auth.currentUser
        let isLoggedIn = (currentUser != nil)
        
        NavigationStack(path: $homePath) {
            ZStack(alignment: .leading){
                
                Color(hex: "#F7FCFD")
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // 1. header profile data
                        if let user = viewModel.dashboardData?.sidemenu.userProfile {
                            HStack(alignment: .top, spacing: 12) {
                                
                                if isLoggedIn {
                                    CachedAsyncImage(url: user.avatarURL, contentMode: .fill)
                                        .frame(width: 54, height: 54)
                                        .clipShape(Circle())
                                } else {
                                    Image("profile")
                                        .renderingMode(.template)
                                        .frame(width: 54, height: 54)
                                        .foregroundStyle(.gray)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    
                                    Text(isLoggedIn ? user.name:"Sign In to SkyPulse")
                                        .fontPoppins(size: 20, weight: .semibold, color: .black.opacity(0.75))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Text(isLoggedIn ? "SkyElite" : "Manage trips & perks")
                                        .fontPoppins(size: 15, weight: .medium, color: isLoggedIn ? .blue:.gray)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.bottom, 8)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                isSideMenu = false
                                if isLoggedIn {
                                    viewModel.selectedTab = .myprofile
                                } else {
                                    showLogin = true
                                }
                                print("test")
                            }
                            
                            Divider()
                        }
                        
                        // 2, menu data
                        if let sideMenu = viewModel.dashboardData?.sidemenu {
                            
                            LazyVStack(spacing: 25){
                                ForEach(sideMenu.menuSections) { menu in
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(menu.sectionTitle)
                                            .fontPoppins(size: 16, weight: .medium, color: .black)
                                        
                                        menuSectionView(menuSection: menu, isLoggedIn: isLoggedIn) { menu in
                                            isSideMenu = false

                                            switch menu.id {
                                            case "item_trips":
                                                if isLoggedIn {
                                                    viewModel.selectedTab = .mybooking
                                                }else {
                                                    showLogin = true
                                                }
                                                
                                            case "item_wallet":
                                                if isLoggedIn {
                                                    homePath.append(HomeRoute.wallet)
                                                }else {
                                                    showLogin = true
                                                }

                                            case "item_offer":
                                                homePath.append(HomeRoute.offers)

                                            case "item_alerts":
                                                homePath.append(HomeRoute.notifications)

                                            case "item_dark_mode":
                                                homePath.append(HomeRoute.settings)

                                            case "item_support":
                                                homePath.append(HomeRoute.support)

                                            case "item_logout":
                                                auth.logout()
                                                
                                            default:
                                                break
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            
                            Text(sideMenu.footer.appVersion)
                                .fontPoppins(size: 14, weight: .regular, color: .blue)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                        }
                    }
                    .background(.clear)
                    .padding(.horizontal, 16)
                    .padding(.top, 66)
                    .padding(.bottom, 34)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.3), value: isSideMenu)
        }
    }
    
    @ViewBuilder
    private func menuSectionView(menuSection: MenuSection, isLoggedIn: Bool, handlerAction: @escaping (MenuItem) -> Void) -> some View {
        
        VStack(alignment: .leading, spacing: 0) {
            ForEach(menuSection.items.indices, id: \.self) { index in
                
                let item = menuSection.items[index]
                let shouldSkip = (item.id == "item_logout" && !isLoggedIn)
                if !shouldSkip {
                    menuItemView(item: item, isLast: (menuSection.items.count == index+1)) { item in
                        handlerAction(item)
                    }
                }
            }
        }
        .padding(.horizontal, 5)
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
    private func menuItemView(item: MenuItem, isLast:Bool, handlerAction: @escaping (MenuItem) -> Void) -> some View {
        
        let color: Color = item.title.lowercased().contains("sign out") ? Color(hex: "#FF453A"):.black
        
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: item.icon)
                    .fontPoppins(size: 20, weight: .semibold, color: color)
                
                Text(item.title)
                    .fontPoppins(size: 18, weight: .regular, color: color)
                
                Spacer()
            }
            Rectangle()
                .fill(.gray.opacity(0.35))
                .frame(height: 1)
                .opacity(isLast ? 0.0:1.0)
        }
        .padding(.leading, 8)
        .padding(.top, 16)
        .frame(maxWidth: .infinity)
        .background(.white)
        .contentShape(Rectangle())
        .onTapGesture {
            handlerAction(item)
        }
    }

}

