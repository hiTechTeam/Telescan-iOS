import SwiftUI

struct People: View {
    
    @EnvironmentObject var peopleViewModel: PeopleViewModel
    
    var body: some View {
        NavigationStack {
            PeopleView()
                .navigationTitle(Inc.people)
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
                Label(Inc.people, systemImage: IncLogos.shareplay)
            } else {
                Label("", systemImage: "shareplay.slash")
            }
        }
        .tag(SelectedTab.near)
        .badge(peopleViewModel.devices.count)
        
    }
}
