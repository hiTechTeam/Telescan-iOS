import SwiftUI

struct PeerListPreview: View {
    let peers: [UserPeer] = [
        UserPeer(id: "1", socialName: "OOxo00__", socialLink: "Telegram"),
        UserPeer(id: "2", socialName: "_givi_", socialLink: "Instagram"),
        UserPeer(id: "3", socialName: "Gog", socialLink: "TG")
    ]
    
    var body: some View {
        List(peers) { peer in
            Button {
                // Действие при нажатии на элемент
            } label: {
                HStack {
                    if let image = peer.profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 48, height: 48)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading) {
                        if !peer.socialName.isEmpty {
                            Text(peer.socialName)
                                .font(.headline)
                        }
                        if !peer.socialLink.isEmpty {
                            Text(peer.socialLink)
                                .font(.subheadline)
                                .foregroundColor(Color(uiColor: .systemBlue))
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        PeerListPreview()
            .navigationTitle("Пользователи рядом")
            .navigationBarTitleDisplayMode(.inline)
    }
}
