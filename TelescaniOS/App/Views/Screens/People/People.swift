import SwiftUI

struct People: View {
    
    @EnvironmentObject var peopleViewModel: PeopleViewModel
    
    private let peopleInc: String = Inc.Tabs.people.localized
    
    var body: some View {
        NavigationStack {
            PeopleView()
                .navigationTitle(peopleInc)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        HStack(spacing: 16) {
                            Button(action: {}) {
                                Image.met
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
        }
        .tabItem {
            if peopleViewModel.isScanningEnabled {
                Label(peopleInc, systemImage: IncLogos.shareplay)
            } else {
                Label("", systemImage: "shareplay.slash")
            }
        }
        .tag(SelectedTab.near)
        .badge(peopleViewModel.devices.count)
        
    }
}
