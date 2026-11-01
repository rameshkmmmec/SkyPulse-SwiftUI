//
//  SplashScreenView.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 01/11/26.
//

import SwiftUI


struct SplashScreenView: View {
    @State private var isAnimating: Bool = false
    @Binding var isSplashActive: Bool

    var body: some View {
        ZStack {
            // Background Theme Color
            Color.blue
                .ignoresSafeArea()

            VStack(spacing: 16) {
                // App Logo
                Image(systemName: "airplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .foregroundColor(.white)
                    .scaleEffect(isAnimating ? 1.0 : 0.6)
                    .opacity(isAnimating ? 1.0 : 0.0)

                Text("SkyPulse")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(isAnimating ? 1.0 : 0.0)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isAnimating = true
            }

            // Splash display delay (1.5 - 2 seconds)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    isSplashActive = false
                }
            }
        }
    }
}
