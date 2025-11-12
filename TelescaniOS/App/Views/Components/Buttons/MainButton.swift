import SwiftUI

struct MainButton: View {
    @StateObject private var viewModel = NextButtonViewModel()
    
    var title: String
    var codeStatus: Bool
    
    let fontSize: CGFloat = 17
    let buttonWidth: CGFloat = 360
    let buttonHeight: CGFloat = 60
    let cornerRadius: CGFloat = 13
    let foregroundOpacity: CGFloat = 0.2
    let backgroundOpacity: CGFloat = 0.2
    let paddingButtom: CGFloat = 16
    
    var body: some View {
        Button(action: {
            if codeStatus == true {
                viewModel.nextAction()
            }
        }) {
            Text(Inc.goNext)
                .font(.system(size: cornerRadius, weight: .semibold))
                .foregroundColor(codeStatus ? Color.white : Color.primary.opacity(foregroundOpacity))
                .frame(width: buttonWidth, height: buttonHeight)
                .background(codeStatus ? Color.deepblue : Color.gray.opacity(backgroundOpacity))
                .cornerRadius(cornerRadius)
        }
        .disabled(codeStatus != true)
        .padding(.bottom, paddingButtom)
    }
}
