import Foundation
import UIKit

@MainActor
final class BotButtonViewModel: ObservableObject {
    
    // MARK: - Functions
    /// Open link to application bot 'Telescan_bot'
    func openBot() {
        guard let url = URL(string: Links.telescanBot) else { return }
        UIApplication.shared.open(url)
    }
}
