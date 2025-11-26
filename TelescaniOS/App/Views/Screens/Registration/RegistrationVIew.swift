import SwiftUI

struct RegView: View {
    @Binding var isRegistered: Bool
    @StateObject private var viewModel = CodeViewModel()
    @FocusState private var isFocused: Bool
    @State private var goNext: Bool = false

    var body: some View {
        VStack {
            ScrollView {
                CodeSpace(isFocused: _isFocused, viewModel: viewModel)
            }
            .onTapGesture { isFocused = false }

            NextButton(codeStatus: $viewModel.codeStatus) {
                viewModel.confirmCode()
                goNext = true
            }
        }
        .navigationDestination(isPresented: $goNext) {
            ScanToggleView(isRegistered: $isRegistered)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                BotButton()
            }
        }
    }
}
