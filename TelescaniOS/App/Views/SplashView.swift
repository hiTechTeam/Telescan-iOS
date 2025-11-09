import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            Image("TsIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Spacer()
            
            Text("Telescan")
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}
