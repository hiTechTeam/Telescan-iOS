import Foundation
import SwiftUI

@MainActor
final class CodeViewModel: ObservableObject {
    
    @Published var tgID: Int? = nil
    @Published var Code: String = ""
    @Published var TgName: String? = nil
    @Published var TgUsername: String? = nil
    @Published var PhotoS3URL: String? = nil
    @Published var isUsernameConfirmed: Bool = false
    
    @Published var codeStatus: Bool? = nil
    @Published var isLoading: Bool = false
    
    @Published var tmpTgUsername: String? = nil
    @Published var tmpCode: String = ""
    private var tmpTgId: Int? = nil
    private var tmpTgName: String? = nil
    private var tmpPhotoS3URL: String? = nil
    
    private let CODECOUNT: Int = 8
    
    func checkCode(_ input: String) {
        guard input.count == CODECOUNT else {
            codeStatus = nil
            tmpTgUsername = nil
            return
        }
        
        isLoading = true
        
        Task {
            let generator = UINotificationFeedbackGenerator()
            do {
                let responseData: GetUserDataByHashedCodeResponse = try await FetchService.fetch.fetchUserDataByHashedCode(for: input)
                self.tmpTgId = responseData.tg_id
                self.tmpTgName = responseData.tg_name
                self.tmpTgUsername = responseData.tg_username
                self.tmpPhotoS3URL = responseData.photoS3URL
                self.codeStatus = true
                self.tmpCode = input
                generator.notificationOccurred(.success)
            } catch {
                self.tmpTgName = nil
                self.tmpTgUsername = nil
                self.codeStatus = false
                generator.notificationOccurred(.error)
            }
            
            isLoading = false
        }
    }
    
    // вызывается при Next / Confirm — только тогда сохраняем в хранилище и ставим confirmed флаг
    func confirmCode() {
        
        self.tgID = tmpTgId
        self.Code = tmpCode
        self.TgName = tmpTgName
        self.TgUsername = tmpTgUsername
        self.PhotoS3URL = tmpPhotoS3URL
        self.isUsernameConfirmed = true
        
        UserDefaults.standard.set(self.tgID, forKey: Keys.tgIdKey.rawValue)
        UserDefaults.standard.set(self.TgName, forKey: Keys.tgNameKey.rawValue)
        UserDefaults.standard.set(self.TgUsername, forKey: Keys.usernameKey.rawValue)
        UserDefaults.standard.set(self.PhotoS3URL, forKey: Keys.photoS3URLKey.rawValue)
        UserDefaults.standard.set(self.Code, forKey: Keys.cleanCodeKey.rawValue)
        
//        self.tmpTgUsername = nil
//        self.tmpCode = ""

    }
}
