import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            Image("AirShareIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
            Spacer()
            
            Text("AirShare")
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.dblue)
    }
}
