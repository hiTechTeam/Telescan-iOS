import SwiftUI

struct TitleField: View {
    
    // MARK: - Inputs
    var text: String
    
    // MARK: - Constants
    private let fontSize: CGFloat = 12
    private let frameWidth: CGFloat = 360
    private let frameHeight: CGFloat = 32
    
    // MARK: - Body
    var body: some View {
        Text(text)
            .font(.system(size: fontSize, weight: .regular))
            .frame(width: frameWidth, height: frameHeight, alignment: .leading)
    }
}
