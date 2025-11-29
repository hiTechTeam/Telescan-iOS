import Foundation

final class UsersProfileStorage {
    static let shared = UsersProfileStorage()
    
    private let filename = "users_profile.json"
    private let profiles: [String : ProfileInfo] = [:]
    private let queue = DispatchQueue(label: "users.profiles.queue", attributes: .concurrent)

}
