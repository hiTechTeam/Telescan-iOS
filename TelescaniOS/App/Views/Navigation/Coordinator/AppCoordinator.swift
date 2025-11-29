import SwiftUI

final class AppCoordinator: ObservableObject, AppCoordinatorProtocol {
    
    @Published var state: AppCoordinatorState
    private let regKey = "isReg"

    init() {
        let isReg = UserDefaults.standard.bool(forKey: regKey)
        self.state = AppCoordinatorState(isRegistered: isReg)
    }

    func start() -> AnyView {
        AnyView(AppCoordinatorView(coordinator: self))
    }

    func completedRegistration() {
        state.isRegistered = true
        UserDefaults.standard.set(true, forKey: regKey)
    }

    func logout() {
        state.isRegistered = false
        UserDefaults.standard.set(false, forKey: regKey)
    }
}
