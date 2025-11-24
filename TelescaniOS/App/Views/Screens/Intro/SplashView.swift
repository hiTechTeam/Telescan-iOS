import SwiftUI

struct SplashView: View {
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    private let vSpacing: CGFloat = 20
    private let frameWidth: CGFloat = 100
    private let frameHeight: CGFloat = 100
    
    var body: some View {
        VStack(spacing: vSpacing) {
            Spacer()
            Image.tsIcon100
                .resizable()
                .scaledToFit()
                .frame(width: frameWidth, height: frameHeight)
            Spacer()
            PoweredDescription()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colorScheme == .dark ?  Color.dark : Color.bl2)
    }
}
