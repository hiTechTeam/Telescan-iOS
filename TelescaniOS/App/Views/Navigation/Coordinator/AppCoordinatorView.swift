import SwiftUI

struct AppCoordinatorView: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        Group {
            if coordinator.isRegistered {
                MainContentView()
            } else {
                Welcome()
            }
        }
        .environmentObject(coordinator)
    }
}
