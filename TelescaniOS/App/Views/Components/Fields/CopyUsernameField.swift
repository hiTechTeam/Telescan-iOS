import SwiftUI
import Combine

struct CopyUsernameField: View {
    
    // MARK: - Inputs
    var username: String
    
    @State private var showCopied = false
    @State private var isPressed = false
    
    private let fieldWidth: CGFloat = 360
    private let fieldHeight: CGFloat = 52
    private let cornerRadius: CGFloat = 13
    private let iconSize: CGFloat = 32
    private let copyAnimationDuration: Double = 0.25
    private let copiedDuration: Double = 1.3
    private let textOffsetY: CGFloat = -50
    private let textOffsetXRussian: CGFloat = 135
    private let textOffsetXOther: CGFloat = 160
    private let labelFontSize: CGFloat = 12
    private let usernameFontSize: CGFloat = 15
    
    private var isRussianLocale: Bool {
        Locale.current.language.languageCode?.identifier == "ru"
    }
    
    private func copyAction() {
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        UIPasteboard.general.string = username
        
        withAnimation(.spring(response: copyAnimationDuration)) {
            isPressed = true
            showCopied = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + copyAnimationDuration) {
            withAnimation(.spring(response: 0.2)) {
                isPressed = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + copiedDuration) {
            withAnimation(.easeOut) {
                showCopied = false
            }
        }
    }
    
    private var copyButton: some View {
        Button {
            copyAction()
        } label: {
            Image.copyUsernameButton
                .resizable()
                .frame(width: iconSize, height: iconSize)
                .padding(.trailing, 20)
                .scaleEffect(isPressed ? 0.88 : 1.0)
                .opacity(isPressed ? 0.6 : 1.0)
        }
    }
    
    private var copiedText: some View {
        Text(Inc.Common.copiedSheet.localized)
            .font(.system(size: labelFontSize))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.black.opacity(0.5)))
            .foregroundColor(.white)
            .padding(.trailing, 25)
            .offset(y: textOffsetY)
            .offset(x: isRussianLocale ? textOffsetXRussian : textOffsetXOther)
            .transition(.opacity.combined(with: .move(edge: .top)))
    }
    
    private var content: some View {
        VStack {
            Text(Inc.Registration.tgUsername)
                .font(.system(size: labelFontSize))
                .frame(width: fieldWidth, alignment: .leading)
            
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.thinblue)
                    .frame(width: fieldWidth, height: fieldHeight)
                
                Text(username)
                    .font(.system(size: usernameFontSize, weight: .medium))
                    .foregroundColor(.bl2)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: 240)
                
                HStack {
                    Spacer()
                    copyButton
                }
                .frame(width: fieldWidth, height: fieldHeight)
                
                if showCopied {
                    copiedText
                }
            }
            
            Text(Inc.Info.copyUsername.localized)
                .foregroundColor(.gray)
                .font(.system(size: labelFontSize, weight: .light))
                .frame(width: fieldWidth)
                .multilineTextAlignment(.center)
                .padding(.top, 4)
        }
    }
    
    // MARK: - Body
    var body: some View {
        content
    }
}
