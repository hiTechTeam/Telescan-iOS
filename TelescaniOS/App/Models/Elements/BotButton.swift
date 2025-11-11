import SwiftUI

struct BotButton: View {
    var title: String = Inc.telescanBot
    var action: () -> Void = {
        if let url = URL(string: Links.telescanBot) {
        UIApplication.shared.open(url)
    }}
    
    let fontSize: CGFloat = 14
    let butthonWidth: CGFloat = 100
    let butthonHeight: CGFloat = 36
    let cornerRadius: CGFloat = 13
    let opacity: Double = 0.3
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize, weight: .semibold))
                .foregroundColor(.blue)
                .frame(width: butthonWidth, height: butthonHeight)
//                .background(Color.blue.opacity(opacity))
                .cornerRadius(cornerRadius)
        }
    }
}
