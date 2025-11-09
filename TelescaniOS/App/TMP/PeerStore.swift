// MARK: - PeerStore
import SwiftUI
import Combine

class PeerStore: ObservableObject, BluetoothManagerDelegate {
    @Published var nearbyPeers: Set<UserPeer> = []
    
    func didDiscoverPeer(_ peer: UserPeer) {
        DispatchQueue.main.async {
            self.nearbyPeers.insert(peer)
        }
    }
    
    func clearPeers() {
        nearbyPeers.removeAll()
    }
}
