import SwiftUI

struct PeopleNearView: View {
    @AppStorage("isScanningEnabled") private var isScanningEnabled = false
    @Binding var profileImage: UIImage?
    
    let socialName: String
    let socialLink: String
    
    @EnvironmentObject var peerStore: PeerStore
    @EnvironmentObject var bluetoothManager: BluetoothManager
    
    var body: some View {
        GeometryReader { geo in
            if !isScanningEnabled {
                placeholderView(
                    title: "Сканирование выключено",
                    description: "Включите сканирование по кнопке выше.\nВ этом режиме вас никто не видит, но и вы не видите других. Если хотите делиться своими контактами и видеть людей рядом — включите сканирование."
                )
            } else if peerStore.nearbyPeers.isEmpty {
                placeholderView(
                    title: "Рядом пока никого нет",
                    description: "Сканирование включено, но поблизости пока никого нет. Оставайтесь на этом экране — как только кто-то рядом начнет делиться, вы увидите его профиль и сможете обменяться контактами."
                )
            } else {
                List(Array(peerStore.nearbyPeers)) { peer in
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
                            if !peer.socialLink.isEmpty {
                                Text(peer.socialLink)
                                    .font(.headline)
                                
                            }
                            if !peer.socialName.isEmpty {
                                Text(peer.socialName)
                                    .font(.subheadline)
                                    .foregroundColor(Color(uiColor: .systemBlue))
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.plain)
            }
        }
        .onAppear {
            bluetoothManager.delegate = peerStore
        }
    }
    
    @ViewBuilder
    private func placeholderView(title: String, description: String) -> some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
