import SwiftUI

struct ScanToggleView: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    
    private let paddingVertical: CGFloat = 24
    private let spacing: CGFloat = 0
    private let regKey: String = GlobalVars.regKey
    private let isScaningKey: String = GlobalVars.isScaningKey
    
    var body: some View {
        ZStack {
            
            Color.tsBackground
                .ignoresSafeArea()
            
            VStack {
                ScrollView {
                    VStack(spacing: spacing) {
                        ScanToggleReg(isScaning: $coordinator.isScaning)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, paddingVertical)
                
                GoButton(isScanning: $coordinator.isScaning) {
                    coordinator.completedRegistration()
                    UserDefaults.standard.set(coordinator.isScaning, forKey: isScaningKey)
                }
            }
        }
        
    }
}
