import SwiftUI

struct Profile: View {
    @State private var savedCode: String = ""
    @State private var showInfoSheet = false
    
    var body: some View {
        NavigationStack {
            ProfileData()
                .navigationTitle(Inc.profile)
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
        .tabItem { Label(Inc.profile, systemImage: IncLogos.personFillViewwfinder) }
        .tag(SelectedTab.profile)
    }
}
