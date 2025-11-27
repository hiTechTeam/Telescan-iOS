import SwiftUI

struct People: View {
    var body: some View {
        NavigationStack {
            PeopleView()
                .navigationTitle(Inc.people)
                .navigationBarTitleDisplayMode(.inline)
        }
        .tabItem { Label(Inc.people, systemImage: IncLogos.shareplay) }
        .tag(SelectedTab.near)
    }
}
