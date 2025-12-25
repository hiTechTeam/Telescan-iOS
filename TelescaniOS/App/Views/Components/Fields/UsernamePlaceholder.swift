import SwiftUI

struct UsernamePlaceholder: View {
    
    // MARK: - Inputs
    var username: String?
    var codeStatus: Bool?
    var isLoading: Bool = false
    
    @State private var animate = false
    @State private var shakeOffset: CGFloat = .zero
    
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
    private let shakeRepeats: Int = 2
    private let shakeOffsetAbs: CGFloat = 4
    private let shakeStepDuration: Double = 0.05
    
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
        for index in 0..<shakeRepeats {
            let delay = Double(index) * shakeStepDuration
            let target: CGFloat = (index.isMultiple(of: 2) ? -shakeOffsetAbs : shakeOffsetAbs)
            
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
    
    private var fieldBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(backgroundColor)
            .frame(width: fieldWidth, height: fieldHeight)
            .scaleEffect(animate ? scaleLarge : scaleSmall)
            .offset(x: shakeOffset)
            .animation(.easeInOut(duration: generalAnimDuration), value: animate)
    }
    
    private var contentText: some View {
        Group {
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
    }
    
    private var content: some View {
        ZStack {
            fieldBackground
            contentText
        }
    }
    
    // MARK: - Body
    var body: some View {
        content
            .onChange(of: codeStatus) { _, newValue in
                if newValue == false {
                    shakeField()
                } else if username != nil {
                    animateField()
                }
            }
    }
}
