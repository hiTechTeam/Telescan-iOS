struct UploadProfileImageRequest: Encodable, Decodable {
    let tgId: Int
    let img: String
}

struct UpdateUserPhotoRequestByTGID: Codable {
    let tgId: Int
    let img: String?
}
