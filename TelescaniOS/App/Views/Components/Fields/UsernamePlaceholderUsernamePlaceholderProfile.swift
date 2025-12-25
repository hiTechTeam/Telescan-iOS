import SwiftUI

struct UsernamePlaceholderProfile: View {
    
    @ObservedObject var authVM: CodeViewModel
    @State private var savedUsername: String = Inc.Registration.usernamePlaceholder
    
    private let cornerRadius: CGFloat = 13
    private let fieldWidth: CGFloat = 360
    private let fieldHeight: CGFloat = 46
    private let textWidth: CGFloat = 280
    private let paddingLeft: CGFloat = 20
    
    private var background: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.tField)
            .opacity(0.8)
            .frame(width: fieldWidth, height: fieldHeight)
            .contentShape(Rectangle())
    }
    
    private var usernameText: some View {
        Text(savedUsername)
            .font(.system(size: 20, weight: .regular))
            .opacity(0.5)
            .frame(width: textWidth, height: fieldHeight, alignment: .leading)
            .padding(.leading, paddingLeft)
    }
    
    private var upButton: some View {
        UpButton(
            viewModel: authVM,
            onUp: {}
        )
        .frame(width: fieldHeight, height: fieldHeight)
        .contentShape(Rectangle())
    }
    
    private var content: some View {
        ZStack {
            background
            HStack(spacing: 0) {
                usernameText
                Spacer()
                upButton
            }
            .frame(width: fieldWidth, height: fieldHeight)
        }
    }
    
    private func updateSavedUsername() {
        if let username = authVM.tgUsername {
            savedUsername = username
        } else if let username = UserDefaults.standard.string(forKey: Keys.usernameKey.rawValue) {
            savedUsername = username
        }
    }
    
    // MARK: - Body
    var body: some View {
        content
            .onAppear { updateSavedUsername() }
            .onChange(of: authVM.tgUsername) { _, newValue in
                if let confirmed = newValue {
                    savedUsername = confirmed
                }
            }
    }
}
