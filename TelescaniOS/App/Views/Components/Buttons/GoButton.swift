import SwiftUI

struct GoButton: View {
    
    // MARK: - Binds
    @Binding var isToggleOn: Bool
    
    // MARK: - Inputs
    var title: String
    var onGo: () -> Void
    
    // MARK: -Constants
    private let fontSize: CGFloat = 20
    private let buttonWidth: CGFloat = 360
    private let buttonHeight: CGFloat = 60
    private let cornerRadius: CGFloat = 13
    private let foregroundOpacity: CGFloat = 0.2
    private let backgroundOpacity: CGFloat = 0.2
    private let paddingButtom: CGFloat = 16
    private let tracking: CGFloat = 1.05
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            if isToggleOn == true {
                onGo()
            }
        }) {
            Text(title)
                .font(.system(size: fontSize, weight: .bold))
                .tracking(tracking)
                .foregroundColor(isToggleOn == true ? Color.white : Color.primary.opacity(foregroundOpacity))
                .frame(width: buttonWidth, height: buttonHeight)
                .background(isToggleOn == true ? Color.deepblue : Color.gray.opacity(backgroundOpacity))
                .cornerRadius(cornerRadius)
                .padding(.bottom, paddingButtom)
        }
        .disabled(isToggleOn != true)
    }
}
