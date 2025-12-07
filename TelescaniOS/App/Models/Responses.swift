struct GetUserDataByHashedCodeResponse: Codable {
    let tg_id: Int?
    let tg_name: String?
    let tg_username: String?
    let photoS3URL: String?
    let hashedCode: String?
}

struct GetUserDataByTGID: Codable {
    let tg_name: String?
    let tg_username: String?
    let photoS3URL: String?
}
