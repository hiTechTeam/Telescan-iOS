import SwiftUI

struct NextButton: View {
    
    // MARK: - Inputs and Binds
    @Binding var codeStatus: Bool?
    var onNext: () -> Void
    
    // MARK: - Constants
    private let title: String = Inc.Onboarding.goNext.localized
    private let fontSize: CGFloat = 20
    private let buttonWidth: CGFloat = 360
    private let buttonHeight: CGFloat = 60
    private let cornerRadius: CGFloat = 13
    private let foregroundOpacity: CGFloat = 0.2
    private let backgroundOpacity: CGFloat = 0.2
    private let paddingButtom: CGFloat = 16
    private let tracking: CGFloat = 1.05
    private let strokeIfTrue: CGFloat = 6
    private let strokeIfFalse: CGFloat = 3
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            if codeStatus == true {
                onNext()
            }
        }) {
            Text(title)
                .font(.system(size: fontSize, weight: .bold))
                .tracking(tracking)
                .foregroundColor(codeStatus == true ? Color.white : Color.primary.opacity(foregroundOpacity))
                .frame(width: buttonWidth, height: buttonHeight)
                .background(codeStatus == true ? Color.bl2 :  Color.primary.opacity(foregroundOpacity))
                .cornerRadius(cornerRadius)
                .padding(.bottom, paddingButtom)
        }
        .disabled(codeStatus != true)
    }
}
