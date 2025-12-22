import SwiftUI

final class AppCoordinatorState: ObservableObject {
    @Published var isRegistered: Bool
    @Published var showSplash: Bool = true
    @Published var isScaning: Bool = false

    init(isRegistered: Bool = false, isScaning: Bool = false) {
        self.isRegistered = isRegistered
        self.isScaning = isScaning
    }
}
