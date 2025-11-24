import SwiftUI

struct RegView: View {
    
    // MARK: - State
    @FocusState private var isFocused: Bool
    @State private var codeStatus: Bool? = nil
    @State private var goNext: Bool = false
    
    // MARK: - Constants
    private let paddingHorizontal: CGFloat = 16
    private let spacing: CGFloat = 0
    
    // MARK: - Body
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: spacing) {
                    CodeSpace(isFocused: _isFocused, codeStatus: $codeStatus)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, paddingHorizontal)
            }
            .contentShape(Rectangle())
            .onTapGesture { isFocused = false }
            
            NextButton(title: Inc.goNext, codeStatus: $codeStatus) {
                goNext = true
            }
        }
        .navigationDestination(isPresented: $goNext) {
            ScanToggleView()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                BotButton()
            }
        }
        .background(Color.tsBackground)
    }
}
