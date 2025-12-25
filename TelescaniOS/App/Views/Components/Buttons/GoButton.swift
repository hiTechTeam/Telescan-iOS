import SwiftUI

struct GoButton: View {
    
    @Binding var isScanning: Bool
    
    var onGo: () -> Void
    
    private let title: String = Inc.Onboarding.goStart.localized
    private let fontSize: CGFloat = 20
    private let buttonWidth: CGFloat = 360
    private let buttonHeight: CGFloat = 60
    private let cornerRadius: CGFloat = 13
    private let foregroundOpacity: CGFloat = 0.2
    private let backgroundOpacity: CGFloat = 0.2
    private let paddingBottom: CGFloat = 16
    private let tracking: CGFloat = 1.05
    
    private var isEnabled: Bool {
        isScanning
    }
    
    private var foregroundColor: Color {
        isEnabled
        ? .white
        : .primary.opacity(foregroundOpacity)
    }
    
    private var backgroundColor: Color {
        isEnabled
        ? .bl2
        : .gray.opacity(backgroundOpacity)
    }
    
    private var buttonText: some View {
        Text(title)
            .font(.system(size: fontSize, weight: .bold))
            .tracking(tracking)
            .foregroundColor(foregroundColor)
            .frame(width: buttonWidth, height: buttonHeight)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .padding(.bottom, paddingBottom)
    }
    
    private func onTap() {
        guard isEnabled else { return }
        onGo()
    }
    
    private var content: some View {
        Button(action: onTap) {
            buttonText
        }
        .disabled(!isEnabled)
    }
    
    // MARK: - Body
    var body: some View {
        content
    }
}
