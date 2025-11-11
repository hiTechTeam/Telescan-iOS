import SwiftUI

struct FieldTitle: View {
    var text: String
    let fontSize: CGFloat = 12
    let frameWidth: CGFloat = 360
    let frameHeight: CGFloat = 32
    
    var body: some View {
        Text(text)
            .font(.system(size: fontSize, weight: .regular))
            .frame(width: frameWidth, height: frameHeight, alignment: .leading)
    }
}
