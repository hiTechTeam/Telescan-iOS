import Foundation
import UIKit

@MainActor
final class NextButtonViewModel: ObservableObject {
    var action: () -> Void = {}
    
    func nextAction() {
        action()
    }
}
