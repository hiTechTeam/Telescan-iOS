
import SwiftUI

struct Field: View {
    @Binding var text: String
    @State private var showWarning: Bool = false
    
    var placeholder: String
    let maxLength: Int = 8
    let fieldWIdth: CGFloat = 360
    let fieldheight: CGFloat = 46
    let fontSizeCode: CGFloat = 20
    let fontSizeSmall: CGFloat = 12
    let cornerRadius: CGFloat = 13
    let paddingH: CGFloat = 13
    
    @ViewBuilder
    private func warningView() -> some View {
        if showWarning {
            Text(Inc.warningCharactersEight)
                .foregroundColor(.gray)
                .font(.system(size: fontSizeSmall))
                .frame(width: fieldWIdth, height: fieldheight, alignment: .center)
                .padding(.leading, fieldWIdth / 2)
                .transition(.opacity)
        }
        
    }
    private func handleTextChange(_ newValue: String) {
        if newValue.count > maxLength {
            text = String(newValue.prefix(maxLength))
            showWarning = true
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showWarning = false
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            TextField(placeholder, text: $text)
                .padding(.horizontal, paddingH)
                .frame(width: fieldWIdth, height: fieldheight)
                .background(Color.tField)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .foregroundColor(.primary)
                .font(.system(size: fontSizeCode))
                .tint(.blue)
                .textInputAutocapitalization(.characters)
                .onChange(of: text) { _, newValue in
                    text = newValue.uppercased()
                    handleTextChange(newValue)
                }
            
            warningView()
        }
        .animation(.easeInOut, value: showWarning)
    }
    
}


