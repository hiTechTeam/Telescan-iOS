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
    @State private var isRegistered: Bool = UserDefaults.standard.bool(forKey: "isReg")
    
    init() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
            UserDefaults.standard.synchronize()
        }
        configureTabBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isRegistered {
                    MainContentView()
                        .overlay(
                            SplashOverlay(isVisible: $showSplash)
                        )
                } else {
                    FirstRegView(isRegistered: $isRegistered)
                        .overlay(
                            SplashOverlay(isVisible: $showSplash)
                        )
                }
            }
            .background(Color.tsBackground)
        }
    }
}
