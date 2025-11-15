import Foundation

@MainActor
final class CodeService {
    
    static let shared = CodeService()
    
    private init() {}
    
    func fetchUsername(for code: String) async throws -> String {
        guard var components = URLComponents(string: Links.telescanApi) else {
            throw URLError(.badURL)
        }
        components.queryItems = [URLQueryItem(name: "code", value: code)]
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode == 200 {
            let json = try JSONDecoder().decode(GetUsernameResponse.self, from: data)
            return "@" + json.tg_username
        } else {
            throw URLError(.badServerResponse)
        }
    }
}
