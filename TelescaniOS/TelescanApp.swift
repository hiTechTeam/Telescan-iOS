//
//  Telescan.swift
//  Telescan
//
//  Created by Ruslan Chukavin on 06.11.2025.
//

import SwiftUI
import Logging
import Kingfisher

@main
struct Telescan: App {
    @StateObject private var coordinator = AppCoordinator()
    private let logger = Logger(label: "cleanAppStorage")
    
    init() {
        #if DEBUG
        cleanAppStorage()
        #endif
    }
    
    private func cleanAppStorage() {
        logger.debug("Clearing application storage (in Debug mode only)")

        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
            UserDefaults.standard.synchronize()
            logger.debug("UserDefaults cleared")
        }

        URLCache.shared.removeAllCachedResponses()
        logger.debug("URLCache cleared")

        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache {
            Logger(label: "cleanAppStorage").debug("Kingfisher cache cleared")
        }

        logger.debug("Storage cleanup complete")
    }
    
    var body: some Scene {
        WindowGroup {
            coordinator.start()
        }
    }
}
