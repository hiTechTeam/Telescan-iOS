//
//  Telescan.swift
//  Telescan
//
//  Created by Ruslan Chukavin on 06.11.2025.
//

import SwiftUI

@main
struct Telescan: App {
    @StateObject private var coordinator = AppCoordinator()
    
    init() {
//        if let bundleID = Bundle.main.bundleIdentifier {
//            UserDefaults.standard.removePersistentDomain(forName: bundleID)
//        }
        
    }
    
    var body: some Scene {
        WindowGroup {
            coordinator.start()
        }
    }
}
