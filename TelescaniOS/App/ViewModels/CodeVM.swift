import Foundation
import SwiftUI

@MainActor
final class CodeViewModel: ObservableObject {
    @Published var code: String = ""
    @Published var username: String? = nil
    @Published var codeStatus: Bool? = nil
    @Published var isLoading = false
    private var didReactToFullCode: Bool = true
    private let codeCount: Int = 8
    
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
            } catch {
                self.username = nil
                self.codeStatus = false
                generator.notificationOccurred(.error)
            }
            
            self.isLoading = false
        }
        
        
    }
}
