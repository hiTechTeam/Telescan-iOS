import SwiftUI

struct CopyUsernameField: View {
    
    @State private var showCopied = false
    @State private var isPressed = false
    
    var username: String
    
    private let fieldWidth: CGFloat = 360
    private let fieldHeight: CGFloat = 52
    private let cornerRadius: CGFloat = 13
    
    let isRussianLocale = Locale.current.language.languageCode?.identifier == "ru"
    
    var body: some View {
        
        VStack {
            Text(Inc.Registration.tgUsername)
                .font(.system(size: 12))
                .frame(width: fieldWidth, alignment: .leading)
            
            ZStack {
                
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.thinblue)
                    .frame(width: fieldWidth, height: fieldHeight)
                
                Text(username)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.bl2)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: 240)
                
                HStack {
                    Spacer()
                    
                    Button {
                        
                        UIImpactFeedbackGenerator(style: .rigid).impactOccurred() // vibration
                        
                        UIPasteboard.general.string = username
                        withAnimation(.spring(response: 0.25)) {
                            isPressed = true
                            showCopied = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            withAnimation(.spring(response: 0.2)) {
                                isPressed = false
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                            withAnimation(.easeOut) {
                                showCopied = false
                            }
                        }
                    } label: {
                        Image.copyUsernameButton
                            .resizable()
                            .frame(width: 32, height: 32)
                            .padding(.trailing, 20)
                            .scaleEffect(isPressed ? 0.88 : 1.0)
                            .opacity(isPressed ? 0.6 : 1.0)
                    }
                }
                .frame(width: fieldWidth, height: fieldHeight)
                
                if showCopied {
                    Text(Inc.Common.copiedSheet.localized)
                        .font(.system(size: 12))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.5))
                        )
                        .foregroundColor(.white)
                        .padding(.trailing, 25)
                        .offset(y: -50)
                        .offset(x: isRussianLocale ? 135 : 160)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            
            Text(Inc.Info.copyUsername.localized)
                .foregroundColor(.gray)
                .font(.system(size: 12, weight: .light))
                .frame(width: fieldWidth)
                .multilineTextAlignment(.center)
                .padding(.top, 4)
        }
    }
}
