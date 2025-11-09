import SwiftUI

struct SplashOverlay: View {
    @Binding var isVisible: Bool
    
    var body: some View {
        if isVisible {
            SplashView()
                .transition(.opacity)
                .zIndex(1)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation(.easeOut(duration: 0.5)) {
                            isVisible = false
                        }
                    }
                }
        }
    }
}
