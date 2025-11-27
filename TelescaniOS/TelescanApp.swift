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
    
    private var contentView: some View {
        Group {
            if isRegistered {
                MainContentView()
            } else {
                RegistrationFlow(isRegistered: $isRegistered)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                contentView
                    .overlay(SplashOverlay(isVisible: $showSplash))
            }
        }
    }
}
