import SwiftUI
import Combine

@MainActor
final class FieldViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var showWarning: Bool = false
    private var warningCancellable: AnyCancellable?
    let maxLength: Int = 8
    let fontSizeCode: CGFloat = 20
    let fontSizeSmall: CGFloat = 12
    
    
    func handleTextChange(_ newValue: inout String) {
        if newValue.count > maxLength {
            text = String(newValue.prefix(maxLength))
            showWarning = true
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            
            warningCancellable?.cancel()
            warningCancellable = Just(())
                .delay(for: .seconds(3), scheduler: RunLoop.main)
                .sink { [weak self] in
                    withAnimation {
                        self?.showWarning = false
                    }
                }
        } else {
            text = newValue
        }
    }
}
