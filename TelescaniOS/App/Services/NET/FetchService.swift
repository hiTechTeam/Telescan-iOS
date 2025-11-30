import Foundation
import CryptoKit

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
        let photoS3Url = json.photoS3Url
        
        let responseData = GetUserDataByHashedCodeResponse(
            tg_id: tg_id,
            tg_name: tg_name,
            tg_username: tg_username != nil ? (at + tg_username!) : nil,
            photoS3Url: photoS3Url,
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
        let photoS3Url = json.photoS3Url
        
        let responseData = GetUserDataByTGID(
            tg_name: tg_name,
            tg_username: tg_username != nil ? (at + tg_username!) : nil,
            photoS3Url: photoS3Url,
        )
        
        return responseData
    }
}
