import SwiftUI

struct RegDescription: View {
    var text: String
    let fontSize: CGFloat = 16
    let frameWidth: CGFloat = 360
    let frameHeight: CGFloat = 42
    let topPadding: CGFloat = 32
    
    var body: some View {
        Text(text)
            .font(.system(size: fontSize, weight: .regular))
            .foregroundColor(.gray)
            .frame(width: frameWidth, height: frameHeight, alignment: .leading)
            .multilineTextAlignment(.center)
            .padding(.top, topPadding)
    }
}
