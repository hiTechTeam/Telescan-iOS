import Foundation
import SwiftUI

@MainActor
final class CodeViewModel: ObservableObject {
    
    // MARK: - Publishing
    @Published var code: String = ""
    @Published var username: String? = nil
    @Published var codeStatus: Bool? = nil
    @Published var isLoading = false
    
    // MARK: - Constants
    private var didReactToFullCode: Bool = true
    private let codeCount: Int = 8
    private let userCode: String = "userCode"
    
    // MARK: - Functions
    /// Checking length correction code and exists username
    func checkCode(_ input: String) {
        guard input.count == codeCount else {
            didReactToFullCode = false
            codeStatus = nil
            username = nil
            return
        }
        
        isLoading = true
        
        Task {
            let generator = UINotificationFeedbackGenerator()
            do {
                let username = try await CodeService.shared.fetchUsername(for: input)
                self.username = username
                self.codeStatus = true
                generator.notificationOccurred(.success)
                UserDefaults.standard.set(self.code, forKey: userCode)
            } catch {
                self.username = nil
                self.codeStatus = false
                generator.notificationOccurred(.error)
            }
            
            self.isLoading = false
        }
        
        
    }
}
