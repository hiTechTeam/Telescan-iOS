import Foundation
import UIKit

@MainActor
final class GoButtonViewModel: ObservableObject {
    
    var action: () -> Void = {}
    
    func goAction() {
        action()
    }
}
