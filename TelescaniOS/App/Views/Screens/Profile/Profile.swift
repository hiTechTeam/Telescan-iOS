import SwiftUI

struct Profile: View {
    @State private var savedCode: String = ""

    var body: some View {
        NavigationStack {
            ProfileView()
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
