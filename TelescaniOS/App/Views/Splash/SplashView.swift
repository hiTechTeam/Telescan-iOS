import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image("TsLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
            Spacer()
            Text("Telescan")
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}
