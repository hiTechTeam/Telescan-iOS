import SwiftUI

struct ProfileView: View {
    @State private var savedCode: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Saved Code:")
                .font(.headline)
            
            Text(savedCode.isEmpty ? "No code saved" : savedCode)
                .font(.title2)
                .foregroundColor(.blue)
        }
        .onAppear {
            // Чтение кода из UserDefaults
            if let code = UserDefaults.standard.string(forKey: "userCode") {
                savedCode = code
            }
        }
        .padding()
    }
}
