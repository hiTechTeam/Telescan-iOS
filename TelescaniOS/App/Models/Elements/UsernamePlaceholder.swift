import SwiftUI

struct UsernamePlaceholder: View {
    var username: String? = nil
    var codeStatus: Bool?
    let placeholder: String = Inc.usernamePlaceholder
    
    let fieldWidth: CGFloat = 360
    let fieldHeight: CGFloat = 46
    let cornerRadius: CGFloat = 13
    let paddingH: CGFloat = 13
    let fontSize: CGFloat = 20
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(backgroundColor)
                .frame(width: fieldWidth, height: fieldHeight)
                .scaleEffect(animate ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.25), value: animate)
            
            Text(displayedText)
                .foregroundColor(textColor)
                .font(.system(size: fontSize))
                .padding(.horizontal, paddingH)
                .frame(width: fieldWidth, height: fieldHeight, alignment: .leading)
        }
        .onChange(of: username) { _, newValue in
            if newValue != nil {
                animateField()
            }
        }
    }
    
    private var displayedText: String {
        if let name = username {
            return name
        } else if codeStatus == false {
            return "incorrect code"
        } else {
            return placeholder
        }
    }
    
    private var backgroundColor: Color {
        if let name = username, !name.isEmpty {
            return Color.blue.opacity(animate ? 0.4 : 0.2)
        } else if codeStatus == false {
            return Color.red.opacity(0.3)
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
        withAnimation(.easeOut(duration: 0.3)) {
            animate = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeIn(duration: 0.3)) {
                animate = false
            }
        }
    }
}
