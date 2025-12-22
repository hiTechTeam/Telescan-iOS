import SwiftUI

struct ScanToggleReg: View {
    
    @Binding var isScaning: Bool
    
    private let spacing: CGFloat = 16
    
    var body: some View {
        VStack(spacing: spacing) {
            ScanToggle(isScaning: $isScaning)
            Description(text: Inc.Scanning.scanToggleDescription.localized)
        }
    }
}
