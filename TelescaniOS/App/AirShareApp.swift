//
//  AirShareApp.swift
//  AirShare
//
//  Created by Ruslan Chukavin on 06.11.2025.
//

import SwiftUI

@main
struct AirShare: App {
    @State private var showSplash = true
    
    init() {
        configureTabBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                SplashOverlay(isVisible: $showSplash)
            }
        }
    }
}

