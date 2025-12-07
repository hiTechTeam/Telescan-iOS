import SwiftUI

struct CodeSpace: View {
    
    @EnvironmentObject var authCodeViewModel: CodeViewModel
    @FocusState private var isCodeFocused: Bool
    
    private let paddingTop: CGFloat = 10
    private let spacing16: CGFloat = 16
    private let frameWidth: CGFloat = 360
    
    private var codeSpace: some View {
        VStack(spacing: spacing16) {
            VStack {
                TitleField(text: Inc.Registration.enterCode.localized)
                CodeField(text: $authCodeViewModel.code)
                    .focused($isCodeFocused)
                    .onTapGesture {
                        isCodeFocused = true
                    }
                    .onChange(of: authCodeViewModel.code) { _, newValue in
                        authCodeViewModel.checkCode(newValue)
                    }
            }
            .padding(.top, paddingTop)
            
            VStack {
                TitleField(text: Inc.Registration.tgUsername)
                UsernamePlaceholder(
                    username: authCodeViewModel.username,
                    codeStatus: authCodeViewModel.codeStatus,
                    isLoading: authCodeViewModel.isLoading
                )
            }
            
            Description(text: Inc.Registration.regDescription.localized)
        }
        .frame(width: frameWidth)
        .onTapGesture {
            isCodeFocused = false
        }
        
        
        
        
    }
    
    var body: some View {
        codeSpace
    }
}
