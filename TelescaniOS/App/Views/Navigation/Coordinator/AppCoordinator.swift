//
//  AppCoordinator.swift
//  Telescan
//
//  Application coordinator. Handles app startup, registration, login/logout, and scanning state management.
//

import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject, AppCoordinatorProtocol {
    
    // MARK: - Constants
    private let regKey: String = Keys.isReg.rawValue
    private let isScaningKey: String = Keys.isScaning.rawValue
    
    // MARK: - Published Properties
    @Published var isRegistered: Bool
    @Published var showSplash: Bool = true
    @Published var isScaning: Bool
    
    // MARK: - ViewModels
    let authCodeViewModel = CodeViewModel()
    let peopleViewModel = PeopleViewModel()
    
    // MARK: - Initialization
    init() {
        self.isRegistered = UserDefaults.standard.bool(forKey: regKey)
        self.isScaning = UserDefaults.standard.bool(forKey: isScaningKey)
    }
    
    // MARK: - Coordinator Methods
    /// Starts the app and returns the main view
    func start() -> AnyView {
        AnyView(
            AppCoordinatorView()
                .environmentObject(self)
                .environmentObject(authCodeViewModel)
                .environmentObject(peopleViewModel)
                .onAppear {
                    self.startScaningIfNeeded()
                }
        )
    }
    
    /// Completes user registration
    func completedRegistration() {
        isRegistered = true
        UserDefaults.standard.set(true, forKey: regKey)
    }
    
    /// Logs out the user
    func logout() {
        isRegistered = false
        UserDefaults.standard.set(false, forKey: regKey)
    }
    
    // MARK: - Private Methods
    /// Starts scanning and BLE advertising if conditions are met
    private func startScaningIfNeeded() {
        guard isRegistered, isScaning else { return }
        
        peopleViewModel.toggleScanning(true)
        
        if let telegramID = UserDefaults.standard.object(forKey: Keys.tgIdKey.rawValue) as? Int {
            BLEManager.shared.startAdvertising(id: String(telegramID))
        }
    }
}
