struct UploadProfileImageRequest: Encodable {
    let tgId: Int
    let img: String
}

struct UpdateUserPhotoRequestByTGID: Codable {
    let tgId: Int
    let img: String?
}
