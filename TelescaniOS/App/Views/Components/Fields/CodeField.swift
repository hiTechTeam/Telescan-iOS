import SwiftUI
import Combine

struct CodeField: View {
    
    @Binding var text: String
    
    @State private var showWarning = false
    @State private var warningCancellable: AnyCancellable?
    
    private let maxLength: Int = 8
    private let fieldWidth: CGFloat = 360
    private let fieldHeight: CGFloat = 46
    private let cornerRadius: CGFloat = 13
    private let paddingH: CGFloat = 13
    private let lineWidth: CGFloat = 1
    private let fontSizeCode: CGFloat = 20
    private let fontSizeSmall: CGFloat = 12
    private let delayWarning: TimeInterval = 3
    private let generator = UINotificationFeedbackGenerator()
    
    private var paddingLeading: CGFloat {
        fieldWidth / 2
    }
    
    private func handleTextChange(_ newValue: String) {
        let uppercased = newValue.uppercased()
        
        guard uppercased.count <= maxLength else {
            text = String(uppercased.prefix(maxLength))
            showLimitWarning()
            return
        }
        
        text = uppercased
    }
    
    private func showLimitWarning() {
        showWarning = true
        generator.notificationOccurred(.warning)
        
        warningCancellable?.cancel()
        warningCancellable = Just(())
            .delay(for: .seconds(delayWarning), scheduler: RunLoop.main)
            .sink {
                withAnimation {
                    showWarning = false
                }
            }
    }
    
    private var textField: some View {
        TextField(
            Inc.Registration.codePlaceholder.localized,
            text: $text
        )
        .padding(.horizontal, paddingH)
        .frame(width: fieldWidth, height: fieldHeight)
        .background(Color.tField)
        .cornerRadius(cornerRadius)
        .overlay(fieldBorder)
        .foregroundColor(.primary)
        .font(.system(size: fontSizeCode))
        .tint(.blue)
        .textInputAutocapitalization(.characters)
        .onChange(of: text) { _, newValue in
            handleTextChange(newValue)
        }
    }
    
    private var fieldBorder: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(Color.gray, lineWidth: lineWidth)
    }
    
    private var warningText: some View {
        Text(Inc.Registration.warningCharactersEight.localized)
            .foregroundColor(.gray)
            .font(.system(size: fontSizeSmall))
            .frame(
                width: fieldWidth,
                height: fieldHeight,
                alignment: .center
            )
            .padding(.leading, paddingLeading)
            .transition(.opacity)
    }
    
    private var content: some View {
        ZStack {
            textField
            if showWarning {
                warningText
            }
        }
    }
    
    // MARK: - Body
    var body: some View {
        content
            .animation(.easeInOut, value: showWarning)
    }
}
