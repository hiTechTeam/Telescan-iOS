struct GetUserDataByHashedCodeResponse: Codable {
    let tgId: Int?
    let tgName: String?
    let tgUsername: String?
    let photoS3URL: String?
    let hashedCode: String?
}

struct GetUserDataByTGID: Codable {
    let tgName: String?
    let tgUsername: String?
    let photoS3URL: String?
}

struct UploadProfileImageResponse: Codable {
    let tgId: Int
    let photoS3URL: String
}
