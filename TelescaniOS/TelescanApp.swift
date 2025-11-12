//
//  Telescan.swift
//  Telescan
//
//  Created by Ruslan Chukavin on 06.11.2025.
//

import SwiftUI

@main
struct Telescan: App {
    @State private var showSplash = true
    
    init() {
        configureTabBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color(Color.tsBackground)
                    .ignoresSafeArea()
                RegView()
                //                ContentView()
                //                BotButton ()
                SplashOverlay(isVisible: $showSplash)
            }
        }
    }
}

