import SwiftUI

struct ScanToggleView: View {
    
    @Binding var isRegistered: Bool
    @State private var isToggleOn: Bool = false
    
    // MARK: - Constants
    private let paddingVertical: CGFloat = 24
    private let spacing: CGFloat = 0
    private let regKey: String = "isReg"
    private let toggleKey: String = "scanToggle"
    
    var body: some View {
        ZStack {
            
            Color.tsBackground
                .ignoresSafeArea()
            
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
                    UserDefaults.standard.set(isToggleOn, forKey: toggleKey)
                    
                    isRegistered = true
                }
            }
        }
        
        
    }
}
