import Foundation
import UIKit

@MainActor
final class BotButtonViewModel: ObservableObject {
    func openBot() {
        guard let url = URL(string: Links.telescanBot) else { return }
        UIApplication.shared.open(url)
    }
}
