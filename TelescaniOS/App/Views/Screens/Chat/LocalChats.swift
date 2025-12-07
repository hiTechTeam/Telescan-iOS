import SwiftUI

struct LocalChats: View {
    var body: some View {
        NavigationStack {
            LocalChatsView()
                .navigationTitle(Inc.Tabs.chats.localized)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {}) {
                            Image.plusChat
                                .foregroundColor(.blue)
                        }
                    }
                }
        }
        .tabItem {
            Label("Chat", systemImage: "bubble.left.and.text.bubble.right")
        }
        .tag(SelectedTab.localChats)
    }
}
