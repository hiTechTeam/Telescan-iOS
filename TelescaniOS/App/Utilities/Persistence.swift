// Utilities/Persistence.swift
import UIKit

struct Persistence {
    static let profileNameKey = "profileName"
    static let socialNameKey = "socialName"
    static let socialLinkKey = "socialLink"
    static let profileImageKey = "profileImage"
    
    static func saveProfile(_ peer: UserPeer) {
        UserDefaults.standard.set(peer.name, forKey: profileNameKey)
        UserDefaults.standard.set(peer.socialName, forKey: socialNameKey)
        UserDefaults.standard.set(peer.socialLink, forKey: socialLinkKey)
        if let data = peer.profileImageData {
            UserDefaults.standard.set(data, forKey: profileImageKey)
        }
    }
    
    static func loadProfile() -> UserPeer {
        let name = UserDefaults.standard.string(forKey: profileNameKey) ?? "User"
        let socialName = UserDefaults.standard.string(forKey: socialNameKey) ?? "Link"
        let socialLink = UserDefaults.standard.string(forKey: socialLinkKey) ?? "@nickname"
        var image: UIImage? = nil
        if let data = UserDefaults.standard.data(forKey: profileImageKey) {
            image = UIImage(data: data)
        }
        return UserPeer(
            id: UUID().uuidString,  // добавляем id
            name: name,
            socialName: socialName,
            socialLink: socialLink,
            profileImage: image
        )
    }
}
