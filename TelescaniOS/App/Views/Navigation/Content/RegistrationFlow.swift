import SwiftUI

struct RegistrationFlow: View {
    @Binding var isRegistered: Bool
    
    var body: some View {
        NavigationStack {
            FirstRegView(isRegistered: $isRegistered)
        }
        
    }
}
