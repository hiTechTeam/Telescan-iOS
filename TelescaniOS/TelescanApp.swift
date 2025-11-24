//
//  Telescan.swift
//  Telescan
//
//  Created by Ruslan Chukavin on 06.11.2025.
//

import SwiftUI

import SwiftUI

struct ContentView2: View {
    
    private static let regKey: String = "isReg"
    
    @State private var isReg: Bool = UserDefaults.standard.bool(forKey: ContentView2.regKey)
    @State private var onStart: Bool = false
    
    var body: some View {
        
        if isReg {
            MainContentView()
        } else {
            FirstRegView(onStart: $onStart)
        }
    }
}

@main
struct Telescan: App {
    @State private var showSplash = true
    
    init() {
        
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        
        configureTabBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color(Color.tsBackground)
                    .ignoresSafeArea()
                ContentView2()
                SplashOverlay(isVisible: $showSplash)
            }
        }
    }
}

