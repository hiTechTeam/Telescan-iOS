// MARK: - PeerStore
import SwiftUI
import Combine

class PeerStore: ObservableObject, BluetoothManagerDelegate {
    @Published var nearbyPeers: Set<UserPeer> = []
    @Published var metPeers: Set<UserPeer> = []
    
    func didDiscoverPeer(_ peer: UserPeer) {
        DispatchQueue.main.async {
            self.nearbyPeers.insert(peer)
        }
    }
    
    func addMetPeer(_ peer: UserPeer) {
        DispatchQueue.main.async {
            self.metPeers.insert(peer)
        }
    }
    
    func clearPeers() {
        nearbyPeers.removeAll()
        metPeers.removeAll()
    }
}
