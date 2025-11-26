import SwiftUI

struct MainContentView: View {
    @State private var selectedTab: SelectedTab = .near
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                NearView()
                    .navigationTitle("People")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem { Label("People", systemImage: IncLogos.shareplay) }
            .tag(SelectedTab.near)
            
            NavigationStack {
                ProfileView()
                    .navigationTitle("Profile")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                // действие info
                            }) {
                                Image(systemName: "info.circle")
                            }
                        }
                    }
            }
            .tabItem { Label("Profile", systemImage: IncLogos.personFillViewwfinder) }
            .tag(SelectedTab.profile)
        }
    }
}
