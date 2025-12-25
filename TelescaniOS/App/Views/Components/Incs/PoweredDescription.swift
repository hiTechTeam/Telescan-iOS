import SwiftUI

struct PoweredDescription: View {
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    private let fontSize: CGFloat = 14
    private let iconWidth: CGFloat = 14
    private let iconHeight: CGFloat = 17
    private let paddingButtom: CGFloat = 16
    private let hSpacing: CGFloat = 4
    
    private var textLabel: some View {
        Text(Inc.Onboarding.poweredByTG.localized)
            .font(.system(size: fontSize, weight: .medium))
            .foregroundColor(colorScheme == .dark ? Color.bl2 : Color.white)
    }
    
    private var icon: some View {
        Image.tgIcon
            .resizable()
            .scaledToFit()
            .frame(width: iconWidth, height: iconHeight)
    }
    
    private var content: some View {
        HStack(spacing: hSpacing) {
            textLabel
            icon
        }
        .padding(.bottom, paddingButtom)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    // MARK: - Body
    var body: some View {
        content
    }
}
