import SwiftUI

struct ScanToggleReg: View {
    
    @Binding var isScaning: Bool
    
    private let spacing: CGFloat = 16
    
    private var content: some View {
        VStack(spacing: spacing) {
            ScanToggle(isScaning: $isScaning)
            Description(text: Inc.Scanning.scanToggleDescription.localized)
        }
    }
    
    var body: some View {
        content
    }
}
