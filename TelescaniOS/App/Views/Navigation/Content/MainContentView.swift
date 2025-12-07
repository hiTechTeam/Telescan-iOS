import SwiftUI

struct MainContentView: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var selectedTab: SelectedTab = .near
    
    var body: some View {
        TabView(selection: $selectedTab) {
            People()
//            LocalChats()
            Profile(authVM: coordinator.authCodeViewModel)
        }
    }
}

