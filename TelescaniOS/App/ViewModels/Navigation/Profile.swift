import SwiftUI

struct Profile: View {
    var body: some View {
        NavigationStack {
            
            ProfileView()
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}
