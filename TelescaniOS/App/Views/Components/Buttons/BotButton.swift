import SwiftUI

struct BotButton: View {
    @StateObject private var viewModel = BotButtonViewModel()
    let fontSize: CGFloat = 14
    let buttonWidth: CGFloat = 100
    let buttonHeight: CGFloat = 36
    let cornerRadius: CGFloat = 13
    
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
