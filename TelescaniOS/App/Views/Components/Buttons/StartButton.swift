import SwiftUI

struct StartButton: View {
    
    // MARK: - Env
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    // MARK: - Inputs
    var title: String
    var onStart: () -> Void
    
    // MARK: - Constants
    private let fontSize: CGFloat = 20
    private let buttonWidth: CGFloat = 360
    private let buttonHeight: CGFloat = 60
    private let cornerRadius: CGFloat = 13
    private let paddingButtom: CGFloat = 16
    private let tracking: CGFloat = 1.05
    private let shadowOpacity: CGFloat = 0.15
    private let shadowRadius: CGFloat = 8
    private let shadowX: CGFloat = 0
    private let shadowY: CGFloat = 4
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            onStart()
        }) {
            HStack{
                Text(title)
                    .font(.system(size: fontSize, weight: .bold))
                    .tracking(tracking)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.bl2)
            }
            .frame(width: buttonWidth, height: buttonHeight)
            .background(colorScheme == .dark ? Color.bl2 : Color.white)
            .cornerRadius(cornerRadius)
            .shadow(color: .black.opacity(shadowOpacity), radius: shadowRadius, x: shadowX, y: shadowY)
            .padding(.bottom, paddingButtom)
        }
        .background(Color.clear)
    }
}


