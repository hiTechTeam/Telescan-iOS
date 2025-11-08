import SwiftUI

struct PeopleNearView: View {
    @AppStorage("isScanningEnabled") private var isScanningEnabled = false
    @Binding var profileImage: UIImage?
    
    let profileName: String
    let socialName: String
    let socialLink: String
    
    @EnvironmentObject var peerStore: PeerStore
    @EnvironmentObject var bluetoothManager: BluetoothManager
    
    var body: some View {
        VStack {
            if !isScanningEnabled {
                Text("Включите сканирование, чтобы видеть людей вокруг")
                    .multilineTextAlignment(.center)
                    .padding()
            } else if peerStore.nearbyPeers.isEmpty {
                Text("Сканирование активно, людей рядом пока нет")
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                List(Array(peerStore.nearbyPeers).sorted { $0.name < $1.name }) { peer in
                    HStack {
                        if let image = peer.profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray)
                        }
                        VStack(alignment: .leading) {
                            Text(peer.name)
                            if !peer.socialName.isEmpty {
                                Text(peer.socialName)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            if !peer.socialLink.isEmpty {
                                Text(peer.socialLink)
                                    .font(.caption2)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            bluetoothManager.delegate = peerStore
        }
    }
}
