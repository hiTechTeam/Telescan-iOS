import SwiftUI

struct PoweredDescription: View {
    
    let fontSize: CGFloat = 14
    let iconWidth: CGFloat = 14
    let iconHeight: CGFloat = 17
    let paddingButtom: CGFloat = 16
    
    var body: some View {
        HStack(spacing: 4){
            Text("Powered by Telegram")
                .font(.system(size: fontSize, weight: .medium))
                .foregroundColor(.white)
            Image("tgIcon")
                .resizable()
                .scaledToFit()
                .frame(width: iconWidth, height: iconHeight)
        }
        .padding(.bottom, paddingButtom)
        .frame(maxWidth: .infinity, alignment: .center)
        
    }
}
