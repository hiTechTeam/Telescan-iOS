import SwiftUI
import Combine

struct CodeField: View {
    
    // MARK: - State
    @State private var showWarning: Bool = false
    @State private var warningCancellable: AnyCancellable?
    
    // MARK: - Binds
    @Binding var text: String
    
    // MARK: - Inputs
    var placeholder: String

    // MARK: - Constants
    private let maxLength: Int = 8
    private let fieldWidth: CGFloat = 360
    private let fieldHeight: CGFloat = 46
    private let cornerRadius: CGFloat = 13
    private let paddingH: CGFloat = 13
    private let lineWidth: CGFloat = 1
    private let fontSizeCode: CGFloat = 20
    private let fontSizeSmall: CGFloat = 12
    private var paddingLeading: CGFloat { fieldWidth / 2 }
    private let delayWarning: TimeInterval = 3

    // MARK: - Functions
    private func handleTextChange(_ newValue: String) {
        if newValue.count > maxLength {
            text = String(newValue.prefix(maxLength))
            showWarning = true

            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)

            warningCancellable?.cancel()
            warningCancellable = Just(())
                .delay(for: .seconds(delayWarning), scheduler: RunLoop.main)
                .sink {
                    withAnimation {
                        showWarning = false
                    }
                }
        } else {
            text = newValue
        }
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            TextField(placeholder, text: $text)
                .padding(.horizontal, paddingH)
                .frame(width: fieldWidth, height: fieldHeight)
                .background(Color.tField)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.gray, lineWidth: lineWidth)
                )
                .foregroundColor(.primary)
                .font(.system(size: fontSizeCode))
                .tint(.blue)
                .textInputAutocapitalization(.characters)
                .onChange(of: text) { _, newValue in
                    handleTextChange(newValue.uppercased())
                }

            if showWarning {
                Text(Inc.warningCharactersEight)
                    .foregroundColor(.gray)
                    .font(.system(size: fontSizeSmall))
                    .frame(width: fieldWidth, height: fieldHeight, alignment: .center)
                    .padding(.leading, paddingLeading)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: showWarning)
    }
}
