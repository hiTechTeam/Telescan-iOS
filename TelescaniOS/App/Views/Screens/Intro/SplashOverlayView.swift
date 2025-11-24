import SwiftUI

struct SplashOverlay: View {
    
    @Binding var isVisible: Bool
    
    private let period: Double = 1
    private let duration: Double = 0.2
    
    var body: some View {
        if isVisible {
            SplashView()
                .transition(.symbolEffect)
                .zIndex(1)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + period) {
                        withAnimation(.easeOut(duration: duration)) {
                            isVisible = false
                        }
                    }
                }
        }
    }
}
