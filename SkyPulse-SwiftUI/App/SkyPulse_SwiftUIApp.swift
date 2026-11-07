//
//  SkyPulse_SwiftUIApp.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 01/11/26.
//

import SwiftUI

@main
struct SkyPulse_SwiftUIApp: App {
    @State private var showSplash: Bool = true
    @State private var authManager = AuthManager.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashScreenView(isSplashActive: $showSplash)
                        .transition(.opacity)
                } else {
                    HomeContainerView()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showSplash)
            .environment(authManager)
        }
    }
}
