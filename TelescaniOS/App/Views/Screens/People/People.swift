import SwiftUI

struct People: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    @EnvironmentObject var peopleViewModel: PeopleViewModel
    @ObservedObject var authVM: CodeViewModel
    
    private let peopNearleInc: String = Inc.Common.nearby.localized
    private let peopleInc: String = Inc.Tabs.people.localized
    
    @State private var showMet = false
    
    var body: some View {
        NavigationStack {
            PeopleView()
                .navigationTitle(peopNearleInc)
                .navigationBarTitleDisplayMode(.automatic)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showMet = true
                        } label: {
                            Image.met
                                .foregroundColor(.gray)
                        }
                    }
                }
                .navigationDestination(isPresented: $showMet) {
                    MetScreen()
                }
        }
        .tabItem {
            if coordinator.isScaning {
                Label(peopleInc, systemImage: IncLogos.shareplay)
            } else {
                Label("", systemImage: "shareplay.slash")
            }
        }
        .tag(SelectedTab.near)
        .badge(peopleViewModel.devices.count)
    }
}

struct MetScreen: View {
    var body: some View {
        Text("Met Screen")
            .navigationTitle(Inc.Tabs.metTitle.localized)
            .navigationBarTitleDisplayMode(.inline)
    }
}

