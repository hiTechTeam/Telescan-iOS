import SwiftUI

struct PoweredDescription: View {
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    // MARK: - Constants
    private let fontSize: CGFloat = 14
    private let iconWidth: CGFloat = 14
    private let iconHeight: CGFloat = 17
    private let paddingButtom: CGFloat = 16
    private let hSpacing: CGFloat = 4
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: hSpacing){
            Text(Inc.Onboarding.poweredByTG.localized)
                .font(.system(size: fontSize, weight: .medium))
                .foregroundColor(colorScheme == .dark ? Color.bl2 : Color.white)
            Image.tgIcon
                .resizable()
                .scaledToFit()
                .frame(width: iconWidth, height: iconHeight)
        }
        .padding(.bottom, paddingButtom)
        .frame(maxWidth: .infinity, alignment: .center)
        
    }
}
