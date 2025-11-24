import SwiftUI

struct ScanToggleView: View {
    
    // MARK: - State
    @State private var isToggleOn: Bool = false
    @State private var goRun: Bool = false
    
    // MARK: - Constants
    private let paddingBottom: CGFloat = 16
    private let paddingVertical: CGFloat = 24
    private let spacing: CGFloat = 0
    private let regKey: String = "isReg"
    
    // MARK: - Body
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: spacing) {
                    ScanToggleReg(isToggleOn: $isToggleOn)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, paddingVertical)
            
            GoButton(isToggleOn: $isToggleOn, title: Inc.go) {
                UserDefaults.standard.set(true, forKey: regKey)
                goRun = true
            }
        }
        .navigationDestination(isPresented: $goRun) {
            MainContentView()
                .navigationBarBackButtonHidden(true)
        }
        .background(Color.tsBackround)
    }
}
