import UIKit
import CoreBluetooth
import SwiftUI

struct UserPeer: Identifiable, Hashable {
    let id: String
    var socialName: String = ""
    var socialLink: String = ""
    var profileImageData: Data? = nil
    
    var profileImage: UIImage? {
        guard let data = profileImageData else { return nil }
        return UIImage(data: data)
    }
    
    init(id: String, socialName: String = "", socialLink: String = "", profileImageData: Data? = nil) {
        self.id = id
        self.socialName = socialName
        self.socialLink = socialLink
        self.profileImageData = profileImageData
    }
    
    init(id: String, socialName: String = "", socialLink: String = "", profileImage: UIImage?) {
        self.id = id
        self.socialName = socialName
        self.socialLink = socialLink
        self.profileImageData = profileImage?.jpegData(compressionQuality: 0.8)
    }

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func ==(lhs: UserPeer, rhs: UserPeer) -> Bool { lhs.id == rhs.id }
}

struct PeerInfo: Codable {
    let id: String
    let socialName: String
    let socialLink: String
    let profileImageData: Data?
}
