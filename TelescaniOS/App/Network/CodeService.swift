import Foundation
import CryptoKit

@MainActor
final class CodeService {
    
    static let shared = CodeService()
    
    private init() {}
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    func fetchUsername(for code: String) async throws -> String {
        let hashedCode = sha256(code)
        
        guard let url = URL(string: Links.telescanApiTunnel) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["hashed_code": hashedCode]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let json = try JSONDecoder().decode(GetUsernameResponse.self, from: data)
        return "@" + json.tg_username
    }
}
