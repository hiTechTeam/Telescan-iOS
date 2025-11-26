import SwiftUI

struct Near: View {
    var body: some View {
        NavigationStack {

            NearView()
                .navigationTitle("People nearby")
                .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}
