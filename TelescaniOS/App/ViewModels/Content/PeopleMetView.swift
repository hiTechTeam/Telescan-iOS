import SwiftUI

struct PeopleMetView: View {
    @EnvironmentObject var peerStore: PeerStore
    
    var body: some View {
        ZStack {
            if peerStore.metPeers.isEmpty {
                Text("Вы никого сегодня не встречали")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(Array(peerStore.metPeers).sorted { $0.name < $1.name }) { peer in
                            Text(peer.name)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
