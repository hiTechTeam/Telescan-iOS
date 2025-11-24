import Foundation
import UIKit

@MainActor
final class GoButtonViewModel: ObservableObject {
    
    // MARK: - Constants and Variables
    var action: () -> Void = {}
    
    // MARK: - Functions
    /// Action to finish registration and use app
    func goAction() {
        action()
    }
}

