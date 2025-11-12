import Foundation
import SwiftUI

@MainActor
final class CodeViewModel: ObservableObject {
    @Published var code: String = ""
    @Published var username: String? = nil
    @Published var codeStatus: Bool? = nil
    private var didReactToFullCode = false
    private let codeCount: Int = 8
    
    func checkCode(_ input: String) {
        if input.count < codeCount {
            didReactToFullCode = false
            codeStatus = nil
            username = nil
            return
        }
        
        guard !didReactToFullCode else { return }
        didReactToFullCode = true
        
        guard var components = URLComponents(string: Links.telescanApi) else { return }
        components.queryItems = [URLQueryItem(name: "code", value: input)]
        guard let url = components.url else { return }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            Task { @MainActor in
                let generator = UINotificationFeedbackGenerator()
                
                if let _ = error {
                    self?.codeStatus = false
                    self?.username = nil
                    generator.notificationOccurred(.error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self?.codeStatus = false
                    self?.username = nil
                    generator.notificationOccurred(.error)
                    return
                }
                
                if httpResponse.statusCode == 200,
                   let data = data,
                   let json = try? JSONDecoder().decode(GetUsernameResponse.self, from: data) {
                    self?.codeStatus = true
                    self?.username = "@" + json.tg_username
                    generator.notificationOccurred(.success)
                } else {
                    self?.codeStatus = false
                    self?.username = nil
                    generator.notificationOccurred(.error)
                }
            }
        }.resume()
    }
}
