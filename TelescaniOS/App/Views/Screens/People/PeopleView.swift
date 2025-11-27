import SwiftUI

import SwiftUI

struct PeopleView: View {
    var body: some View {
        ZStack {
            
            Color.tsBackground
                .ignoresSafeArea()
            
            VStack {
                Text("People nearby content")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        
    }
}
