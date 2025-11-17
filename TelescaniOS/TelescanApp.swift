//
//  Telescan.swift
//  Telescan
//
//  Created by Ruslan Chukavin on 06.11.2025.
//

import SwiftUI

struct ContentView2: View {
    @State private var isScanning: Bool = false
    
    var body: some View {
        //        ScanToggle(isOn: $isScanning)
        RegView()
        
    }
}

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
                //                BotButton ()
                ContentView2()
                SplashOverlay(isVisible: $showSplash)
            }
        }
    }
}

