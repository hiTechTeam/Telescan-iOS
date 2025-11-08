//
//  TelescaniOSApp.swift
//  TelescaniOS
//
//  Created by Ruslan Chukavin on 06.11.2025.
//

import SwiftUI

@main
struct TelescaniOSApp: App {
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
            ContentView()
        }
    }
}
