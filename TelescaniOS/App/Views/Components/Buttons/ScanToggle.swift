import SwiftUI

struct ScanToggle: View {
    @Binding var isOn: Bool
    
    private let frameWidth: CGFloat = 360
    private let frameHeight: CGFloat = 46
    private let cornerRadius: CGFloat = 13
    private let paddingHorizontal: CGFloat = 14
    private let fontSize: CGFloat = 16
    
    var body: some View {
        VStack{
            HStack {
                Text(Inc.scanning)
                    .foregroundColor(.primary)
                    .font(.system(size: fontSize, weight: .medium))
                
                Spacer()
                
                Toggle("", isOn: $isOn)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
            }
            .padding(.horizontal, paddingHorizontal)
            .frame(width: frameWidth, height: frameHeight)
            .background(Color.grOne)
            .cornerRadius(cornerRadius)
        }.background(Color.tsBackground)
    }
    
    
}
