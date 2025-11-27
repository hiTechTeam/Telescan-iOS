import SwiftUI

struct ScanToggle: View {
    
    // MARK: - Binds
    @Binding var isToggleOn: Bool
    
    // MARK: - Constants
    private let frameWidth: CGFloat = 360
    private let frameHeight: CGFloat = 46
    private let cornerRadius: CGFloat = 13
    private let paddingHorizontal: CGFloat = 14
    private let fontSize: CGFloat = 16
    private let imageSize: CGFloat = 28
    
    // MARK: - Body
    var body: some View {
        HStack {
            Image.iconEye // "dot.radiowaves.forward"
                .resizable()
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)

            Toggle(Inc.scanning, isOn: $isToggleOn)
                .toggleStyle(SwitchToggleStyle(tint: .green))
        }
        .padding(.horizontal, paddingHorizontal)
        .frame(width: frameWidth, height: frameHeight)
        .background(Color.grOne)
        .cornerRadius(cornerRadius)
    }
}


