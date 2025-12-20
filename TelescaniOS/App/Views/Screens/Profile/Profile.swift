import SwiftUI

struct Profile: View {
    
    @ObservedObject var authVM: CodeViewModel
    @State private var showInfoSheet = false
    
    private let profileInc: String = Inc.Tabs.profile.localized
    
    var body: some View {
        NavigationStack {
            ProfileDataView(authCodeViewModel: authVM)
                .navigationTitle(authVM.TgName ?? profileInc)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
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
        .onAppear {
            if let tgName = UserDefaults.standard.string(forKey: Keys.tgNameKey.rawValue) {
                authVM.TgName = tgName
            }
            
            if let code = UserDefaults.standard.string(forKey: Keys.cleanCodeKey.rawValue) {
                authVM.Code = code
            }
            
            if let username = UserDefaults.standard.string(forKey: Keys.usernameKey.rawValue) {
                authVM.TgUsername = username
            }
        }
        .tabItem { Label(profileInc, systemImage: IncLogos.personFillViewwfinder) }
        .tag(SelectedTab.profile)
    }
}
