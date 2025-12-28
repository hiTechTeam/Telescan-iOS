import SwiftUI

struct StartButton: View {
    
    // MARK: - Inputs
    var title: String
    
    var onStart: () -> Void
    
    private let fontSize: CGFloat = 14
    private let buttonWidth: CGFloat = 360
    private let buttonHeight: CGFloat = 60
    private let cornerRadius: CGFloat = 13
    private let paddingBottom: CGFloat = 16
    private let tracking: CGFloat = 1.0
    private let shadowOpacity: CGFloat = 0.15
    private let shadowRadius: CGFloat = 8
    private let shadowX: CGFloat = 0
    private let shadowY: CGFloat = 4
    private let iconWidth: CGFloat = 18
    private let iconHeight: CGFloat = 21
    
    private func onTap() {
        onStart()
    }
    
    private var titleView: some View {
        Text(title)
            .font(.system(size: fontSize, weight: .semibold))
            .tracking(tracking)
            .foregroundColor(.dark)
    }
    
    private var iconView: some View {
        Image.tgIconDark
            .resizable()
            .scaledToFit()
            .frame(width: iconWidth, height: iconHeight)
    }
    
    private var buttonContent: some View {
        HStack {
            titleView
            iconView
        }
        .frame(width: buttonWidth, height: buttonHeight)
        .background(Color.white)
        .cornerRadius(cornerRadius)
        .shadow(
            color: .black.opacity(shadowOpacity),
            radius: shadowRadius,
            x: shadowX,
            y: shadowY
        )
        .padding(.bottom, paddingBottom)
    }
    
    private var content: some View {
        Button(action: onTap) {
            buttonContent
        }
        .background(Color.clear)
    }
    
    // MARK: - Body
    var body: some View {
        content
    }
}
