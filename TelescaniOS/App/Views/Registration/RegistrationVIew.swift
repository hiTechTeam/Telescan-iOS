import SwiftUI

struct RegView: View {
    @FocusState private var isFocused: Bool
    @State private var codeStatus: Bool? = nil  // поднимаем сюда
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(spacing: 0) {
                        CodeSpace(codeStatus: $codeStatus, isFocused: _isFocused)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                }
                .contentShape(Rectangle())
                .onTapGesture { isFocused = false }
                
                MainButton(title: Inc.goNext, codeStatus: codeStatus ?? false) { }
            }
            .navigationTitle(Inc.registration)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    BotButton()
                }
            }
        }
    }
}
