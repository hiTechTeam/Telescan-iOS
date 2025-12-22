import SwiftUI

struct UsernamePlaceholder: View {
    
    // MARK: - Inputs
    var username: String?
    var codeStatus: Bool?
    var isLoading: Bool = false
    
    // MARK: - State
    @State private var animate = false
    @State private var shakeOffset: CGFloat = .zero
    
    // MARK: - Constants
    private let usernameField: String = Inc.Registration.usernamePlaceholder
    private let incorrectCodeText: String = Inc.Registration.incorrectCode.localized
    private let fieldWidth: CGFloat = 360
    private let fieldHeight: CGFloat = 46
    private let cornerRadius: CGFloat = 13
    private let paddingHorizontal: CGFloat = 12
    private let fontSizeNormal: CGFloat = 20
    private let fontSizeIncorrect: CGFloat = 14
    private let activeOpacity: CGFloat = 0.2
    private let animatedOpacity: CGFloat = 0.4
    private let scaleSmall: CGFloat = 1.0
    private let scaleLarge: CGFloat = 1.1
    private let scaleAnimDuration: Double = 0.3
    private let generalAnimDuration: Double = 0.25
    private let shakeInitialIndex: Int = 0
    private let shakeRepeats: Int = 2
    private let shakeOffsetAbs: CGFloat = 4
    private let shakeStepDuration: Double = 0.05
    
    // MARK: - Computed values
    private var displayedText: String {
        if let name = username {
            return name
        }
        if codeStatus == false {
            return incorrectCodeText
        }
        return usernameField
    }
    private var computedFontSize: CGFloat {
        if let status = codeStatus {
            return status ? fontSizeNormal : fontSizeIncorrect
        }
        return fontSizeNormal
    }
    private var backgroundColor: Color {
        if let name = username, !name.isEmpty {
            return Color.blue.opacity(animate ? animatedOpacity : activeOpacity)
        }
        if codeStatus == false {
            return Color.red.opacity(activeOpacity)
        }
        return .clear
    }
    private var textColor: Color {
        if let name = username, !name.isEmpty {
            return .blue
        }
        if codeStatus == false {
            return .red
        }
        return .gray
    }
    
    // MARK: - Functions
    private func animateField() {
        withAnimation(.easeOut(duration: scaleAnimDuration)) {
            animate = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + scaleAnimDuration) {
            withAnimation(.easeIn(duration: scaleAnimDuration)) {
                animate = false
            }
        }
    }
    private func shakeField() {
        for index in shakeInitialIndex ..< (shakeInitialIndex + shakeRepeats) {
            let delay = Double(index - shakeInitialIndex) * shakeStepDuration
            let target: CGFloat = (index.isMultiple(of: shakeRepeats) ? -shakeOffsetAbs : shakeOffsetAbs)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.linear(duration: shakeStepDuration)) {
                    shakeOffset = target
                }
            }
        }
        
        let resetDelay = Double(shakeRepeats) * shakeStepDuration
        DispatchQueue.main.asyncAfter(deadline: .now() + resetDelay) {
            withAnimation(.linear(duration: shakeStepDuration)) {
                shakeOffset = .zero
            }
        }
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(backgroundColor)
                .frame(width: fieldWidth, height: fieldHeight)
                .scaleEffect(animate ? scaleLarge : scaleSmall)
                .offset(x: shakeOffset)
                .animation(.easeInOut(duration: generalAnimDuration), value: animate)
            
            if isLoading {
                ProgressView()
                    .frame(height: fieldHeight)
                    .padding(.leading, paddingHorizontal)
            } else {
                Text(displayedText)
                    .foregroundColor(textColor)
                    .font(.system(size: computedFontSize))
                    .padding(.horizontal, paddingHorizontal)
                    .frame(width: fieldWidth, height: fieldHeight, alignment: .leading)
            }
            
        }
        .onChange(of: codeStatus) { _, newValue in
            if newValue == false {
                shakeField()
            } else if username != nil {
                animateField()
            }
        }
    }
}
