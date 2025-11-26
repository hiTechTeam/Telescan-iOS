import SwiftUI

struct CodeSpace: View {
    
    // MARK: - State
    @FocusState var isFocused: Bool
    @ObservedObject var viewModel: CodeViewModel
    
    // MARK: - Constants
    private let paddingTop: CGFloat = 10
    private let spacing1: CGFloat = 16
    private let spacing2: CGFloat = 0
    private let frameWidth: CGFloat = 360
    
    // MARK: - Calculated VIew properties
    private var codeSpace: some View {
        VStack(spacing: spacing1) {
            VStack(spacing: spacing2) {
                TitleField(text: Inc.enterCode)
                CodeField(text: $viewModel.code, placeholder: Inc.code)
                    .focused($isFocused)
                    .onChange(of: viewModel.code) { _, newValue in
                        viewModel.checkCode(newValue)
                    }
            }
            .padding(.top, paddingTop)
            
            VStack(spacing: spacing2) {
                TitleField(text: Inc.tgUsername)
                UsernamePlaceholder(
                    username: viewModel.username,
                    codeStatus: viewModel.codeStatus,
                    isLoading: viewModel.isLoading
                )
            }
            Description(text: Inc.regDescription)
        }
        .frame(width: frameWidth)
    }
    
    // MARK: - Body
    var body: some View {
        codeSpace
    }
}
