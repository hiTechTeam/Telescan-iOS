//
//  Telescan.swift
//  Telescan
//
//  Created by Ruslan Chukavin on 06.11.2025.
//

import SwiftUI
import Logging

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
        
        logger.debug("Clearing app storage (Debug mode)")
        
        // 1. Clear UserDefaults (all saved settings, tokens, codes, etc.)
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
            UserDefaults.standard.synchronize()
            logger.debug("UserDefaults cleared")
        }
        
        // 2. Clear URLCache (cached network responses and images)
        URLCache.shared.removeAllCachedResponses()
        logger.debug("URLCache cleared")
        
        // 3. Clear app's caches directory
        let fileManager = FileManager.default
        let cachesURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        
        do {
            let cachesContents = try fileManager.contentsOfDirectory(at: cachesURL, includingPropertiesForKeys: nil)
            for file in cachesContents {
                try fileManager.removeItem(at: file)
            }
            logger.debug("Caches directory cleared")
        } catch {
            logger.debug("Error clearing caches: \(error.localizedDescription)")
        }
        
        logger.debug("Full app storage cleanup completed")
    }
    
    var body: some Scene {
        WindowGroup {
            coordinator.start()
        }
    }
    
    
}
