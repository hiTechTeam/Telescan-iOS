import Foundation
import CryptoKit
import PhotosUI

@MainActor
final class FetchService {
    
    // MARK: - Singleton
    static let fetch = FetchService()
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Constants
    private let POST: String = "POST"
    private let formatJSON: String = "application/json"
    private let contentType: String = "Content-Type"
    private let hashedCodeKey: String = "hashed_code"
    private let tgIDKey: String = "tg_id"
    private let at: String = "@"
    private let hexoFOrmat: String = "%02x"
    private let statusSuccess: Int = 200
    
    // MARK: - Functions
    /// Make sha256 code hash
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: hexoFOrmat, $0) }.joined()
    }
    
    func fetchUserDataByHashedCode(for code: String) async throws -> GetUserDataByHashedCodeResponse
    {
        let hashedCode = sha256(code)
        
        guard let url = URL(string: Links.telescanApiTunnel) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = POST
        request.setValue(formatJSON, forHTTPHeaderField: contentType)
        
        let body: [String: String] = [hashedCodeKey: hashedCode]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == statusSuccess else {
            throw URLError(.badServerResponse)
        }
        
        let json = try JSONDecoder().decode(
            GetUserDataByHashedCodeResponse.self,
            from: data
        )
        
        let tg_id = json.tg_id
        let tg_name = json.tg_name
        let tg_username = json.tg_username
        let photoS3URL = json.photoS3URL
        
        let responseData = GetUserDataByHashedCodeResponse(
            tg_id: tg_id,
            tg_name: tg_name,
            tg_username: tg_username != nil ? (at + tg_username!) : nil,
            photoS3URL: photoS3URL,
            hashedCode: hashedCode
        )
        
        return responseData
    }
    
    
    func fetchUserDataByTGID(for tgID: Int) async throws -> GetUserDataByTGID
    {
        
        guard let url = URL(string: Links.telescanApiGetuser) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = POST
        request.setValue(formatJSON, forHTTPHeaderField: contentType)
        
        let body: [String: Int] = [tgIDKey: tgID]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == statusSuccess else {
            throw URLError(.badServerResponse)
        }
        
        let json = try JSONDecoder().decode(
            GetUserDataByHashedCodeResponse.self,
            from: data
        )
        
        let tg_name = json.tg_name
        let tg_username = json.tg_username
        let photoS3URL = json.photoS3URL
        
        let responseData = GetUserDataByTGID(
            tg_name: tg_name,
            tg_username: tg_username != nil ? (at + tg_username!) : nil,
            photoS3URL: photoS3URL,
        )
        
        return responseData
    }
    
    func uploadProfileImage(tgID: Int, image: UIImage) async throws -> String {
        // Кодируем UIImage в JPEG
        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
            throw NSError(domain: "encode_error", code: 0)
        }

        // Структуры запроса и ответа
        struct Request: Encodable {
            let tg_id: Int
            let img: String // Base64
        }

        struct Response: Decodable {
            let tg_id: Int
            let photoS3URL: String
        }

        // Формируем URL и запрос
        guard let url = URL(string: Links.telescanApiUploadPhoto) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = Request(tg_id: tgID, img: imageData.base64EncodedString())
        request.httpBody = try JSONEncoder().encode(body)

        // Выполняем запрос
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        // Декодируем ответ
        let decoded = try JSONDecoder().decode(Response.self, from: data)
        return decoded.photoS3URL
    }
    
    func deleteProfileImage(tgID: Int) async throws {
        guard let url = URL(string: "\(Links.telescanApiDeletePhoto)/\(tgID)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
}
