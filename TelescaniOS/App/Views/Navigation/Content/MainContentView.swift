import SwiftUI

struct MainContentView: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var selectedTab: SelectedTab = .near
    @State private var previousTab: SelectedTab = .near
    @State private var showScanAlert = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            People(authVM: coordinator.authCodeViewModel)
            Profile(authVM: coordinator.authCodeViewModel)
        }
        .onAppear {
            if coordinator.isScaning == false {
                selectedTab = .profile
                previousTab = .profile
            }
        }
        .onChange(of: selectedTab) { _, newValue in
            if newValue == .near && coordinator.isScaning == false {
                showScanAlert = true
                selectedTab = previousTab
            } else {
                previousTab = newValue
            }
        }
        .alert(Inc.Scanning.justTurnScaning.localized, isPresented: $showScanAlert) {
            Button(Inc.Common.okey, role: .cancel) { }
        } message: {
            Text(Inc.Scanning.scanAlertText.localized)
        }
    }
}
