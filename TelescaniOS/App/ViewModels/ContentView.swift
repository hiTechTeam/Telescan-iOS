import SwiftUI

struct ContentView: View {
    @State private var selectedTab: SelectedTab = .near
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            Near()
                .tabItem { Label(Inc.people, systemImage: IncLogos.shareplay) }
                .tag(SelectedTab.near)
            
            Profile()
                .tabItem { Label(Inc.profile, systemImage: IncLogos.personFillViewwfinder) }
                .tag(SelectedTab.profile)
        }
    }
}
