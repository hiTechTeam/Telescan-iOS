import SwiftUI

struct GoButton: View {
    
    @Binding var isScanning: Bool
    
    var onGo: () -> Void
    
    private let fontSize: CGFloat = 20
    private let buttonWidth: CGFloat = 360
    private let buttonHeight: CGFloat = 60
    private let cornerRadius: CGFloat = 13
    private let foregroundOpacity: CGFloat = 0.2
    private let backgroundOpacity: CGFloat = 0.2
    private let paddingButtom: CGFloat = 16
    private let tracking: CGFloat = 1.05
    
    var body: some View {
        Button(
            action: {
                if isScanning {
                    onGo()
                }
            },
            label: {
                Text(Inc.Onboarding.goStart.localized)
                    .font(.system(size: fontSize, weight: .bold))
                    .tracking(tracking)
                    .foregroundColor(isScanning ? Color.white : Color.primary.opacity(foregroundOpacity))
                    .frame(width: buttonWidth, height: buttonHeight)
                    .background(isScanning ? Color.bl2 : Color.gray.opacity(backgroundOpacity))
                    .cornerRadius(cornerRadius)
                    .padding(.bottom, paddingButtom)
            }
        )
        .disabled(isScanning != true)
    }
}
