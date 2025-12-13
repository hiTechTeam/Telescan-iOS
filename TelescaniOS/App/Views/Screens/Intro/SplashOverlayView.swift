import SwiftUI

struct SplashOverlay: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    
    private let period: Double = 1
    
    private var splashView: some View {
        SplashView()
            .zIndex(1)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + period) {
                    coordinator.showSplash = false
                }
            }
    }
    
    var body: some View {
        splashView
    }
}
