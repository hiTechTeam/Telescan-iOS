import SwiftUI

struct Profile: View {
    
    @State private var savedName: String = ""
    @State private var savedCode: String = ""
    @State private var showInfoSheet = false
    
    private let tgNameKey = "tgName"
    
    var body: some View {
        NavigationStack {
            ProfileData()
                .navigationTitle(savedName.isEmpty ? Inc.profile : savedName)
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
        .onAppear {
            if let name = UserDefaults.standard.string(forKey: tgNameKey) {
                savedName = name
            }
        }
        .tabItem { Label(Inc.profile, systemImage: IncLogos.personFillViewwfinder) }
        .tag(SelectedTab.profile)
    }
}
