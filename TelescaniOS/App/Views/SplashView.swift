import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
<<<<<<< HEAD
            Image("TsIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Spacer()
            
            Text("Telescan")
=======
            Image("AirShareIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
            Spacer()
            
            Text("AirShare")
>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
<<<<<<< HEAD
        .background(Color.black)
=======
        .background(Color.dblue)
>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b
    }
}
