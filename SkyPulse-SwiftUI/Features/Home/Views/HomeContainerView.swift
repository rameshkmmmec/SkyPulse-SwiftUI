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
    @State private var showLogin: Bool = false

    @State private var router = NavigationRouter()
    @State private var homePath: [HomeRoute] = []
    
    @State private var profilePath = NavigationPath()
    @State private var myTripsPath = NavigationPath()
    @Environment(AuthManager.self) private var auth

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
                             homePath.append(HomeRoute.notifications)
                        } onSelect: { module in
                            homePath.append(HomeRoute.module(id: module.id))
                        }
                        .navigationDestination(for: HomeRoute.self) { route in
                            
                            switch route {
                            case .myTrips:
                                if auth.currentUser != nil {
                                    MyTripsView()
                                }else {
                                    Color.clear
                                        .onAppear {
                                            viewModel.selectedTab = .home
                                        }
                                }
                                
                            case .profile:
                                if let user = auth.currentUser {
                                    MyProfileView(user: user)
                                }else {
                                    Color.clear
                                        .onAppear {
                                            viewModel.selectedTab = .home
                                        }
                                }
                            case .wallet:
                                if auth.currentUser != nil {
                                    WalletRewordView()
                                }
                            case .offers:
                                OffersView()
                            case .notifications:
                                AppNotificationsView()
                            case .settings:
                                AppSettingsView()
                            case .support:
                                HelpCenterView()
                                
                                
                            case .module(let id):
                                switch id {
                                case "srv_flight":
                                    FlightSearchView(vm: viewModel)
                                case "srv_hotels":
                                    HotelSearchView()
                                case "srv_trains":
                                    TrainSearchView()
                                case "srv_cabs":
                                    CabSearchView()
                                default:
                                    EmptyView()
                                }
                            }
                        }
                    }
                case .myprofile:
                    
                    if let user = auth.currentUser {
                        NavigationStack(path: $profilePath) {
                            MyProfileView(user: user)
                        }
                    } else {
                        Color.clear
                            .onAppear {
                                viewModel.selectedTab = .home
                                showLogin = true
                            }
                    }
                case .mybooking:
                    if let user = auth.currentUser {
                        NavigationStack(path: $myTripsPath) {
                            MyTripsView()
                        }
                    }else {
                        Color.clear
                            .onAppear {
                                viewModel.selectedTab = .home
                                showLogin = true
                            }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if shouldShowTabbar {
                VStack() {
                    Spacer()
                    HomeTabView(viewModel: viewModel)
                }
            }
            configureSideMenu
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .customBottomSheet(isPresented: $showLogin) {
            LoginView(){
                showLogin = false
            }
        }
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
                SideMenuView(viewModel: viewModel, isSideMenu: $isSideMenu, showLogin: $showLogin, homePath: $homePath)
                    .containerRelativeFrame(.horizontal) { lenght, axis in
                        lenght * 0.8
                    }
                    .background(Color.white)
                    .transition(.move(edge: .leading))
            }
            .zIndex(1)
        }
    }
    
    private var shouldShowTabbar: Bool {
        guard let currentRoute = homePath.last else { return true }
        return !currentRoute.hideTabbar
    }
}
