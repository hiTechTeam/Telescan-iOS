import SwiftUI

struct ScanToggleReg: View {
    
    // MARK: - Binds
    @Binding var isToggleOn: Bool
    
    // MARK: - Constants
    private let spacing: CGFloat = 16
    
    // MARK: - Calculated VIew properties
    private var scanToggleView: some View {
        VStack(spacing: spacing) {
            ScanToggle(isToggleOn: $isToggleOn)
            Description(text: Inc.scanToggleDescription)
        }
    }
    
    // MARK: - Body
    var body: some View {
        scanToggleView
    }
}
