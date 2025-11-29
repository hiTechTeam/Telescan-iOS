struct GetUsernameResponse: Codable {
    let tg_id: Int?
    let tg_name: String?
    let tg_username: String?
    let photoS3Url: String?
    let hashedCode: String?
}
