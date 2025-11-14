import SwiftUI

struct UsernamePlaceholder: View {
    @State private var animate = false
    @State private var shakeOffset: CGFloat = 0
    
    var username: String? = nil
    var codeStatus: Bool?
    let placeholder: String = Inc.usernamePlaceholder
    let fieldWidth: CGFloat = 360
    let fieldHeight: CGFloat = 46
    let cornerRadius: CGFloat = 13
    let paddingH: CGFloat = 13
    
    private var displayedText: String {
        if let name = username {
            return name
        } else if codeStatus == false {
            return Inc.incorrectCode
        } else {
            return placeholder
        }
    }
    private var fontSize: CGFloat {
        if let status = codeStatus {
            return status ? 20 : 14
        } else {
            return 20
        }
    }
    private var backgroundColor: Color {
        if let name = username, !name.isEmpty {
            return Color.blue.opacity(animate ? 0.4 : 0.2)
        } else if codeStatus == false {
            return Color.red.opacity(0.2)
        } else {
            return Color.clear
        }
    }
    private var textColor: Color {
        if let name = username, !name.isEmpty {
            return .blue
        } else if codeStatus == false {
            return .red
        } else {
            return .gray
        }
    }
    
    private func animateField() {
        withAnimation(.easeOut(duration: 0.3)) { animate = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeIn(duration: 0.3)) { animate = false }
        }
    }
    private func shakeField() {
        let times = 2
        let offset: CGFloat = 4
        for i in 0..<times {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.05) {
                withAnimation(.linear(duration: 0.05)) {
                    shakeOffset = i % 2 == 0 ? -offset : offset
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(times) * 0.05) {
            withAnimation(.linear(duration: 0.05)) { shakeOffset = 0 }
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(backgroundColor)
                .frame(width: fieldWidth, height: fieldHeight)
                .scaleEffect(animate ? 1.1 : 1.0)
                .offset(x: shakeOffset)
                .animation(.easeInOut(duration: 0.25), value: animate)
            
            Text(displayedText)
                .foregroundColor(textColor)
                .font(.system(size: fontSize))
                .padding(.horizontal, paddingH)
                .frame(width: fieldWidth, height: fieldHeight, alignment: .leading)
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
