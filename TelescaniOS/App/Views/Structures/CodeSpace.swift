import SwiftUI

struct CodeSpace: View {
    @Binding var codeStatus: Bool?
    @FocusState var isFocused: Bool
    @StateObject private var viewModel = CodeViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 0) {
                TitleField(text: Inc.enterCode)
                Field(text: $viewModel.code, placeholder: Inc.code)
                    .focused($isFocused)
                    .onChange(of: viewModel.code) { _, newValue in
                        viewModel.checkCode(newValue)
                    }
                    .onReceive(viewModel.$codeStatus) { status in
                        codeStatus = status
                    }
            }
            .padding(.top, 10)
            
            VStack(spacing: 0) {
                TitleField(text: Inc.tgUsername)
                UsernamePlaceholder(username: viewModel.username, codeStatus: viewModel.codeStatus)
            }
            
            RegDescription(text: Inc.regDescription)
        }
        .frame(width: 360)
    }
}
