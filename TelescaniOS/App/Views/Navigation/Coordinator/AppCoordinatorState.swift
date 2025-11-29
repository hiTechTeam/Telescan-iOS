import SwiftUI

final class AppCoordinatorState: ObservableObject {
    @Published var isRegistered: Bool
    @Published var showSplash: Bool = true

    init(isRegistered: Bool = false) {
        self.isRegistered = isRegistered
    }
}

