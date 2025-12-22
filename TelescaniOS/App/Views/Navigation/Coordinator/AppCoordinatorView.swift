import SwiftUI

struct AppCoordinatorView: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    
    private var contentVIew: some View {
        Group {
            if coordinator.isRegistered {
                MainContentView()
            } else {
                Welcome()
            }
        }
        .environmentObject(coordinator)
//        .overlay {
//            if coordinator.showSplash {
//                SplashOverlay()
//            }
//        }
        .environmentObject(coordinator)
        
    }
    
    var body: some View {
        contentVIew
    }
}
