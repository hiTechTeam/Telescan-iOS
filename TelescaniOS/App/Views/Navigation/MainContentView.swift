import SwiftUI

struct MainContentView: View {
    @State private var selectedTab: SelectedTab = .near
    
    var body: some View {
        TabView(selection: $selectedTab) {
            People()
            Profile()
        }
    }
}

