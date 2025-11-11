import SwiftUI

struct MainButton: View {
    var title: String = Inc.goNext
    var codeStatus: Bool
    var action: () -> Void = {}
    
    let fontSize: CGFloat = 17
    let buttonWidth: CGFloat = 360
    let buttonHeight: CGFloat = 60
    let cornerRadius: CGFloat = 13
    let opacity: Double = 0.2
    
    var body: some View {
        Button(action: {
            if codeStatus == true {
                action()
            }
        }) {
            Text(title)
                .font(.system(size: fontSize, weight: .semibold))
                .foregroundColor(codeStatus ? Color.primary : Color.white.opacity(0.2))
                .frame(width: buttonWidth, height: buttonHeight)
                .background(codeStatus ? Color.deepblue : Color.gray.opacity(opacity))
                .cornerRadius(cornerRadius)
        }
        .disabled(codeStatus != true)
        .padding(.bottom, 16)
    }
}
