import SwiftUI

struct AuthCode: View {
    
    @EnvironmentObject var authCodeViewModel: CodeViewModel
    @State private var goNext: Bool = false
    
    var body: some View {
        ZStack {
            
            Color.tsBackground
                .ignoresSafeArea()
            
            VStack {
                ScrollView {
                    CodeSpace()
                    Color.clear.frame(width: 390, height: 8)
                }
                
                NextButton(codeStatus: $authCodeViewModel.codeStatus) {
                    authCodeViewModel.confirmCode()
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
        }
    }
}
