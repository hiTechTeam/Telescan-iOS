import SwiftUI

struct ScanToggleReg: View {
    
    // MARK: - Binds
    @Binding var isToggleOn: Bool
    
    // MARK: - Constants
    private let spacing: CGFloat = 16
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: spacing) {
            ScanToggle(isToggleOn: $isToggleOn)
            Description(text: Inc.scanToggleDescription)
        }
    }
}
