import SwiftUI

struct Description: View {
    
    // MARK: - Inputs
    var text: String
    
    private let fontSize: CGFloat = 16
    private let frameWidth: CGFloat = 360
    private let frameHeight: CGFloat = 42
    private let topPadding: CGFloat = 32
    
    private var content: some View {
        Text(text)
            .font(.system(size: fontSize, weight: .regular))
            .foregroundColor(.gray)
            .frame(width: frameWidth, alignment: .leading)
            .multilineTextAlignment(.center)
            .padding(.top, topPadding)
    }
    
    // MARK: - Body
    var body: some View {
        content
    }
}
