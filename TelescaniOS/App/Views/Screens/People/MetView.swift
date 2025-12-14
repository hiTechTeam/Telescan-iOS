import SwiftUI

struct MetView: View {
    var body: some View {
        ZStack {
            Color.tsBackground.ignoresSafeArea()
            Text("Met Screen")
                .navigationTitle(Inc.Tabs.metTitle.localized)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

