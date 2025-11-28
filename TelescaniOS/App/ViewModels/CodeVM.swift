import Foundation
import SwiftUI

@MainActor
final class CodeViewModel: ObservableObject {

    @Published var code: String = ""
    @Published var tgName: String? = nil
    @Published var username: String? = nil          // имя, полученное из проверки (видно сразу)
    @Published var codeStatus: Bool? = nil
    @Published var isLoading = false

    // подтверждённые значения (для UI/профиля)
    @Published var confirmedCode: String? = nil
    @Published var confirmedTgName: String? = nil
    @Published var confirmedUsername: String? = nil
    @Published var isUsernameConfirmed: Bool = false

    private let codeCount = 8
    private let userCodeKey = "userCode"
    private let tgNameKey = "tgName"
    private let usernameKey = "username"
    private let hashedCodeKey = "hashedCode"

    private var pendingHashedCode: String?

    func checkCode(_ input: String) {
        guard input.count == codeCount else {
            // если длина не равна — сброс статуса проверки, но не трогаем confirmed*
            codeStatus = nil
            username = nil
            return
        }

        isLoading = true

        Task {
            let generator = UINotificationFeedbackGenerator()
            do {
                let (tgName, tgUsername, hashedCode) = try await CodeService.shared.fetchUsername(for: input)
                // обновляем username и статус — видно сразу в UI
                self.tgName = tgName
                self.username = tgUsername
                self.codeStatus = true
                self.code = input
                self.pendingHashedCode = hashedCode
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
        UserDefaults.standard.set(code, forKey: userCodeKey)
        
        if let name = tgName {
            UserDefaults.standard.set(name, forKey: tgNameKey)
        }
        
        if let u = username {
            UserDefaults.standard.set(u, forKey: usernameKey)
        }
       
        UserDefaults.standard.set(hashed, forKey: hashedCodeKey)

        pendingHashedCode = nil
    }
}
