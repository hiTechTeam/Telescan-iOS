import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject, AppCoordinatorProtocol {
    
    @Published var isRegistered: Bool
    @Published var showSplash: Bool = true
    @Published var isScaning: Bool
    
    let authCodeViewModel = CodeViewModel()
    let peopleViewModel = PeopleViewModel()
    
    private let regKey: String = Keys.isReg.rawValue
    private let isScaningKey: String = Keys.isScaning.rawValue
    
    init() {
        self.isRegistered = UserDefaults.standard.bool(forKey: regKey)
        self.isScaning = UserDefaults.standard.bool(forKey: isScaningKey)
    }
    
    func start() -> AnyView {
        AnyView(
            AppCoordinatorView()
                .environmentObject(self)
                .environmentObject(authCodeViewModel)
                .environmentObject(peopleViewModel)
                .onAppear {
                    guard self.isRegistered, self.isScaning else { return }
                    self.peopleViewModel.toggleScanning(true)
                    
                    if let tgID = UserDefaults.standard.object(forKey: Keys.tgIdKey.rawValue) as? Int {
                        BLEManager.shared.startAdvertising(id: String(tgID))
                    }
                }
        )
    }
    
    func completedRegistration() {
        isRegistered = true
        UserDefaults.standard.set(true, forKey: regKey)
    }
    
    func logout() {
        isRegistered = false
        UserDefaults.standard.set(false, forKey: regKey)
    }
}
