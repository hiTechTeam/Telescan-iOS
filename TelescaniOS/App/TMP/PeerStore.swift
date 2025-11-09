<<<<<<< HEAD
//// MARK: - PeerStore
//import SwiftUI
//import Combine
//
//class PeerStore: ObservableObject, BluetoothManagerDelegate {
//    @Published var nearbyPeers: Set<UserPeer> = []
//
//    func didDiscoverPeer(_ peer: UserPeer) {
//        DispatchQueue.main.async {
//            self.nearbyPeers.insert(peer)
//        }
//    }
//
//    func clearPeers() {
//        nearbyPeers.removeAll()
//    }
//}


//class ProfileStore: ObservableObject {
//    @AppStorage("socialName") var socialName: String = ""
//    @AppStorage("socialLink") var socialLink: String = ""
//    @AppStorage("profileImageBase64") private var profileImageBase64: String = ""
//
//    @Published var profileImage: UIImage? {
//        didSet {
//            if let image = profileImage,
//               let data = image.jpegData(compressionQuality: 0.8) {
//                profileImageBase64 = data.base64EncodedString()
//            } else {
//                profileImageBase64 = ""
//            }
//        }
//    }
//
//    init() {
//        if let data = Data(base64Encoded: profileImageBase64) {
//            profileImage = UIImage(data: data)
//        }
//    }
//
//    func saveImage(_ image: UIImage) {
//        profileImage = image
//    }
//}

import SwiftUI
import Combine

class ProfileStore: ObservableObject {
    @Published var profileImage: UIImage? {
        didSet {
            saveImageToStorage(profileImage)
        }
    }
    @AppStorage("socialName") var socialName: String = ""
    @AppStorage("socialLink") var socialLink: String = ""
    @AppStorage("profileImageBase64") private var profileImageBase64: String = ""
    
    init() {
        if let data = Data(base64Encoded: profileImageBase64),
           let image = UIImage(data: data) {
            profileImage = image
        }
    }
    
    func saveImage(_ image: UIImage) {
        profileImage = image
    }
    
    private func saveImageToStorage(_ image: UIImage?) {
        if let image = image,
           let data = image.jpegData(compressionQuality: 0.8) {
            profileImageBase64 = data.base64EncodedString()
        } else {
            profileImageBase64 = ""
        }
    }
}

=======
// MARK: - PeerStore
import SwiftUI
import Combine

>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b
class PeerStore: ObservableObject, BluetoothManagerDelegate {
    @Published var nearbyPeers: Set<UserPeer> = []
    
    func didDiscoverPeer(_ peer: UserPeer) {
        DispatchQueue.main.async {
            self.nearbyPeers.insert(peer)
        }
    }
<<<<<<< HEAD
=======
    
    func clearPeers() {
        nearbyPeers.removeAll()
    }
>>>>>>> 0737f3bef726169980a7f7b16f757ee1159fde4b
}
