import SwiftUI

struct BotButton: View {
    @StateObject private var viewModel = BotButtonViewModel()
    
    private let fontSize: CGFloat = 14
    private let buttonWidth: CGFloat = 100
    private let buttonHeight: CGFloat = 36
    private let cornerRadius: CGFloat = 13
    
    var body: some View {
        Button(
            action: {
                viewModel.openBot()
            },
            label: {
                Text(Inc.Profile.telescanBot)
                    .font(.system(size: fontSize, weight: .semibold))
                    .foregroundColor(.blue)
                    .frame(width: buttonWidth, height: buttonHeight)
                    .cornerRadius(cornerRadius)
            }
        )
    }
}
