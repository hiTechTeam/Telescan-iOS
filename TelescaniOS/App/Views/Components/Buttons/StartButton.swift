import SwiftUI

struct StartButton: View {
    
    // MARK: - Env
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    // MARK: - Inputs
    var title: String
    var onStart: () -> Void
    
    // MARK: - Constants
    private let fontSize: CGFloat = 14
    private let buttonWidth: CGFloat = 280
    private let buttonHeight: CGFloat = 48
    private let cornerRadius: CGFloat = 48
    private let paddingButtom: CGFloat = 16
    private let tracking: CGFloat = 1.0
    private let shadowOpacity: CGFloat = 0.15
    private let shadowRadius: CGFloat = 8
    private let shadowX: CGFloat = 0
    private let shadowY: CGFloat = 4
    private let iconWidth: CGFloat = 18
    private let iconHeight: CGFloat = 21
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            onStart()
        }) {
            HStack() {
                Text(title)
                    .font(.system(size: fontSize, weight: .semibold))
                    .tracking(tracking)
                    .foregroundColor(Color.dark)
                Image.tgIconDark
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconWidth, height: iconHeight)
            }
            .frame(width: buttonWidth, height: buttonHeight)
            .background(Color.white)
            .cornerRadius(cornerRadius)
            .shadow(color: .black.opacity(shadowOpacity), radius: shadowRadius, x: shadowX, y: shadowY)
            .padding(.bottom, paddingButtom)
        }
        .background(Color.clear)
    }
}


