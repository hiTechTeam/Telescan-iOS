struct ProfileInfo: Codable, Identifiable {
    let id: String // telegram ID
    let tgName: String?
    let tgusername: String
    let photoS3URL: String?
    
    var cachedLocalPhotoPath: String? // ???: May be it not need
}

struct NearbyUser: Identifiable {
    let id: String          // TGID как строка, ключ словаря
    let tgName: String?
    let tgUsername: String?
    let photoURL: String?
}
