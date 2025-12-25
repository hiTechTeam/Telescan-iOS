import SwiftUI

struct CodeSpace: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    @EnvironmentObject var authCodeViewModel: CodeViewModel
    @FocusState private var isCodeFocused: Bool
    
    private let frameWidth: CGFloat = 360
    
    private var content: some View {
        VStack(spacing: 16) {
            VStack(spacing: 4) {
                TitleField(text: Inc.Registration.enterCode.localized)
                CodeField(text: $authCodeViewModel.tmpCode)
                    .focused($isCodeFocused)
                    .onTapGesture {
                        isCodeFocused = true
                    }
                    .onChange(of: authCodeViewModel.tmpCode) { _, newValue in
                        authCodeViewModel.checkCode(newValue)
                    }
            }
            VStack(spacing: 4) {
                TitleField(text: Inc.Registration.tgUsername)
                UsernamePlaceholder(
                    username: authCodeViewModel.tmpTgUsername,
                    codeStatus: authCodeViewModel.codeStatus,
                    isLoading: authCodeViewModel.isLoading
                )
            }
            
            Description(text: Inc.Registration.regDescription.localized)
        }
        .padding(.top, 10)
        .frame(width: frameWidth)
        .onTapGesture {
            isCodeFocused = false
        }
    }
    
    // MARK: - Body
    var body: some View {
        content
    }
}
