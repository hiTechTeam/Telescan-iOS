import SwiftUI

struct AppCoordinatorView: View {
    @StateObject private var peopleViewModel = PeopleViewModel()
    @ObservedObject var coordinator: AppCoordinator
    
    private var contentVIew: some View {
        Group {
            if coordinator.state.isRegistered {
                MainContentView()
            } else {
                RegistrationFlow(isRegistered: $coordinator.state.isRegistered)
            }
        }
        .environmentObject(peopleViewModel)
    }
    
    var body: some View {
        contentVIew
            .overlay(SplashOverlay(isVisible: $coordinator.state.showSplash))
    }
}
