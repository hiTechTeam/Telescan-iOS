struct ProfileInfo: Codable, Identifiable {
    let id: String // telegram ID
    let tgName: String?
    let tgusername: String
    let photoS3URL: String?
    
    var cachedLocalPhotoPath: String? // ???: May be it not need
}
