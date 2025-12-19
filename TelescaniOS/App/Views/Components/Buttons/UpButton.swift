import SwiftUI

struct UpButton: View {
    
    @ObservedObject var viewModel: CodeViewModel
    
    @State private var showSheet = false
    @FocusState private var isFocused: Bool
    
    var onUp: () -> Void
    
    private let cornerRadius: CGFloat = 13
    
    var body: some View {
        Button {
            onUp()
            showSheet = true
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 46, height: 46)
                Image(.upChevron)
                    .scaleEffect(0.8)
            }
        }
        .sheet(isPresented: $showSheet) {
            
            VStack {
                HStack {
                    BotButton()
                }
                .frame(width: 360, height: 46, alignment: .trailing)
                .padding(.top, 24)
                
                CodeSpace()
                
                Spacer()
                
                ConfirmButton(codeStatus: $viewModel.codeStatus) {
                    viewModel.confirmCode()
                    
                    if viewModel.codeStatus == true {
                        showSheet = false
                        
                        if let tgID = UserDefaults.standard.object(forKey: Keys.tgIdKey.rawValue) as? Int {
                            BLEManager.shared.restartAdvertising(id: String(tgID))
                        }
                        
                    }
                }
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
            .onTapGesture { isFocused = false }
        }
    }
}
