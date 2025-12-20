struct UploadProfileImageRequest: Encodable {
    let tg_id: Int
    let img: String
}

struct UpdateUserPhotoRequestByTGID: Codable {
    let tg_id: Int
    let img: String?
}
