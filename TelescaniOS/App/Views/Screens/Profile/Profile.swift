import SwiftUI

struct Profile: View {
    
//    @EnvironmentObject var coordinator: AppCoordinator
    @ObservedObject var authVM: CodeViewModel
    @State private var savedName: String = ""
    @State private var showInfoSheet = false
    
    private let tgNameKey = "tgName"
    private let profileInc: String = Inc.Tabs.profile.localized
    
    var body: some View {
        NavigationStack {
            ProfileDataView(authCodeViewModel: authVM)
                .navigationTitle(authVM.confirmedTgName ?? profileInc)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showInfoSheet = true
                        }) {
                            Image.infoImage
                                .foregroundColor(.gray)
                        }
                    }
                }
                .sheet(isPresented: $showInfoSheet) {
                    InfoSheetView()
                        .presentationDetents([.large])
                        .presentationDragIndicator(.visible)
                }
        }
        .tabItem { Label(profileInc, systemImage: IncLogos.personFillViewwfinder) }
        .tag(SelectedTab.profile)
    }
}
