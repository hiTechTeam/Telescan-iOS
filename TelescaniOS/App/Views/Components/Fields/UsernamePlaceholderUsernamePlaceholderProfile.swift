import SwiftUI

struct UsernamePlaceholderProfile: View {
    
    @ObservedObject var authVM: CodeViewModel
    @State var savedUsername: String = Inc.Registration.usernamePlaceholder
    
    private let cornerRadius: CGFloat = 13
    private let fieldWidth: CGFloat = 360
    private let fieldHeight: CGFloat = 46
    private let textWidth: CGFloat = 280
    private let paddingLeft: CGFloat = 20
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.tField)
                .opacity(0.8)
                .frame(width: fieldWidth, height: fieldHeight)
                .contentShape(Rectangle())
            
            HStack(spacing: 0) {
                Text(savedUsername)
                    .font(.system(size: 20, weight: .regular))
                    .opacity(0.5)
                    .frame(width: textWidth, height: fieldHeight, alignment: .leading)
                    .padding(.leading, paddingLeft)
                
                Spacer()
                
                UpButton(
                    viewModel: authVM,
                    onUp: {}
                )
                .frame(width: fieldHeight, height: fieldHeight)
                .contentShape(Rectangle())
            }
            .frame(width: fieldWidth, height: fieldHeight)
        }
        .onAppear {
            if let username = authVM.TgUsername {
                savedUsername = username
            } else if let username = UserDefaults.standard.string(forKey: Keys.usernameKey.rawValue) {
                savedUsername = username
            }
        }
        .onChange(of: authVM.TgUsername) { _, newValue in
            if let confirmed = newValue {
                savedUsername = confirmed
            }
        }
    }
}
