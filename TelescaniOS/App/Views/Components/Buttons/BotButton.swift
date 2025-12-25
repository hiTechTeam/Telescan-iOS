import SwiftUI

struct BotButton: View {
    
    @StateObject private var viewModel = BotButtonViewModel()
    
    private let title: String = Inc.Profile.telescanBot
    private let fontSize: CGFloat = 14
    private let buttonWidth: CGFloat = 100
    private let buttonHeight: CGFloat = 36
    private let cornerRadius: CGFloat = 13
    
    private func onTap() {
        viewModel.openBot()
    }
    
    private var buttonText: some View {
        Text(title)
            .font(.system(size: fontSize, weight: .semibold))
            .foregroundColor(.blue)
            .frame(width: buttonWidth, height: buttonHeight)
            .cornerRadius(cornerRadius)
    }
    
    private var content: some View {
        Button(action: onTap) {
            buttonText
        }
    }
    
    // MARK: - Body
    var body: some View {
        content
    }
}
