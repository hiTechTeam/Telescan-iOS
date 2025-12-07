import SwiftUI

struct SplashOverlay: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    
    private let period: Double = 1
    private let duration: Double = 0.2
    
    private var splashView: some View {
        SplashView()
            .transition(.opacity)
            .zIndex(1)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + period) {
                    withAnimation(.linear(duration: duration)){
                        coordinator.showSplash = false
                    }
                }
            }
        
    }
    
    var body: some View {
        splashView
    }
}
