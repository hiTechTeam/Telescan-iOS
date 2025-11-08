//
//  TelescaniOSApp.swift
//  TelescaniOS
//
//  Created by Ruslan Chukavin on 06.11.2025.
//

import SwiftUI

@main
struct TelescaniOSApp: App {
    @State private var showSplash = true

    init() {
        // Настройка шрифта и цвета для Tab Bar
        let appearance = UITabBarAppearance()
        
        // Нормальное состояние
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 12, weight: .bold),
        ]
        
        // Активное состояние
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 12, weight: .bold),
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView() // основной контент

                if showSplash {
                    SplashView()
                        .transition(.opacity)
                        .zIndex(1)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    showSplash = false
                                }
                            }
                        }
                }
            }
        }
    }
}

// Сплэш-экран
struct SplashView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            Image("AirShareIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
            Spacer()
            
            Text("AirShare")
                .font(.headline)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.dblue)
    }
}
