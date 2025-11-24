import SwiftUI

struct BotButton: View {
    
    // MARK: - State
    @StateObject private var viewModel = BotButtonViewModel()
    
    // MARK: - Constants
    private let fontSize: CGFloat = 14
    private let buttonWidth: CGFloat = 100
    private let buttonHeight: CGFloat = 36
    private let cornerRadius: CGFloat = 13
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            viewModel.openBot()
        }) {
            Text(Inc.telescanBot)
                .font(.system(size: fontSize, weight: .semibold))
                .foregroundColor(.blue)
                .frame(width: buttonWidth, height: buttonHeight)
                .cornerRadius(cornerRadius)
        }
    }
}
