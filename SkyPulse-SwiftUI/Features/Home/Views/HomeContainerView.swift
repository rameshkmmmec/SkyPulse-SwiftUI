//
//  HomeContainerView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 01/11/26.
//

import SwiftUI

struct HomeContainerView: View {
    
    @StateObject var viewModel: HomeViewModel
    @State private var isSideMenu: Bool = false

    @State private var router = NavigationRouter()
    @State private var homePath = NavigationPath()
    @State private var profilePath = NavigationPath()
    @State private var myTripsPath = NavigationPath()

    init() {
        _viewModel = StateObject(wrappedValue: HomeViewModel())
    }
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            Group {
                switch viewModel.selectedTab {
                case .home:
                    NavigationStack(path: $homePath) {
                        
                        HomeView(vm: viewModel) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isSideMenu = true
                            }
                        } onSelectNotify: {
                            // homePath.append(HomeRoute.notifications)
                        }
                    }
                case .myprofile:
                    NavigationStack(path: $profilePath) {
                        MyProfileView()
                    }
                case .mybooking:
                    NavigationStack(path: $myTripsPath) {
                        MyTripsView()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack() {
                Spacer()
                HomeTabView(viewModel: viewModel)
            }
            
            configureSideMenu
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    @ViewBuilder
    private var configureSideMenu: some View{
        
        if isSideMenu {
            
            ZStack(alignment: .leading) {
                // Background Dimming
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut) { isSideMenu = false }
                    }
                SideMenuView(viewModel: viewModel, isSideMenu: $isSideMenu)
                    .containerRelativeFrame(.horizontal) { lenght, axis in
                        lenght * 0.8
                    }
                    .background(Color.white)
                    .transition(.move(edge: .leading))
            }
            .zIndex(1)
        }
    }
}
