import Foundation
import SwiftUI

@MainActor
final class CodeViewModel: ObservableObject {

    @Published var tgId: Int? = nil
    @Published var tgName: String? = nil
    @Published var username: String? = nil
    @Published var photoS3Url: String? = nil
    @Published var code: String = ""
    
    @Published var codeStatus: Bool? = nil
    @Published var isLoading = false

    @Published var confirmedCode: String? = nil
    @Published var confirmedTgName: String? = nil
    @Published var confirmedUsername: String? = nil
    @Published var isUsernameConfirmed: Bool = false

    private let codeCount = 8
    private let userCodeKey = "userCode"
    private let tgIdKey = "tg_id"
    private let tgNameKey = "tgName"
    private let usernameKey = "username"
    private let photoS3UrlKey = "photoS3Url"
    private let hashedCodeKey = "hashedCode"
    
    private var pendingHashedCode: String?

    func checkCode(_ input: String) {
        guard input.count == codeCount else {
            codeStatus = nil
            username = nil
            return
        }

        isLoading = true

        Task {
            let generator = UINotificationFeedbackGenerator()
            do {
                let responseData: GetUsernameResponse = try await CodeService.shared.fetchUsername(for: input)
                self.tgId = responseData.tg_id
                self.tgName = responseData.tg_name
                self.username = responseData.tg_username
                self.photoS3Url = responseData.photoS3Url
                self.pendingHashedCode = responseData.hashedCode
                self.codeStatus = true
                self.code = input
                generator.notificationOccurred(.success)
            } catch {
                self.tgName = nil
                self.username = nil
                self.codeStatus = false
                generator.notificationOccurred(.error)
            }
            isLoading = false
        }
    }

    // вызывается при Next / Confirm — только тогда сохраняем в хранилище и ставим confirmed флаг
    func confirmCode() {
        guard codeStatus == true, let hashed = pendingHashedCode else { return }

        // обновляем confirmed значения
        self.confirmedCode = code
        self.confirmedTgName = tgName
        self.confirmedUsername = username
        self.isUsernameConfirmed = true

        // сохраняем в UserDefaults
        
        if let tgId = tgId {
            UserDefaults.standard.set(tgId, forKey: tgIdKey)
        }
        
        if let name = tgName {
            UserDefaults.standard.set(name, forKey: tgNameKey)
        }
        
        if let u = username {
            UserDefaults.standard.set(u, forKey: usernameKey)
        }
        
        if let photoS3UrlLink = photoS3Url {
            UserDefaults.standard.set(photoS3UrlLink, forKey: photoS3UrlKey)
        }
       
        UserDefaults.standard.set(hashed, forKey: hashedCodeKey)

        pendingHashedCode = nil
    }
}
