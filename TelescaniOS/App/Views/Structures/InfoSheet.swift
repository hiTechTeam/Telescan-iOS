import SwiftUI

struct InfoSheetView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            VStack(spacing: 16) {
                Text("Telegram Integration")
                    .font(.system(size: 20, weight: .medium))
                    .multilineTextAlignment(.center)
                Text("The app extends Telegram's functionality and uses it as the main communication channel. Telescan enables instant exchange of Telegram usernames via Bluetooth.")
                    .font(.system(size: 12, weight: .medium))
                    .frame(maxWidth: 360)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 48)
            
            VStack(alignment: .leading, spacing: 16) {
                
                InfoItem(
                    icon: "person.2.fill",
                    title: "Instant Contact Exchange",
                    description: "Exchange contact information with other participants instantly."
                )
                
                InfoItem(
                    icon: "bolt.fill",
                    title: "Fast and Offline",
                    description: "Uses Bluetooth for offline code hash exchange."
                )
                
                InfoItem(
                    icon: "lock.fill",
                    title: "Data Protection",
                    description: "All data is securely protected: code hashes are stored on the server, and only the account owner can link their Telegram."
                )
                
                InfoItem(
                    icon: "network",
                    title: "Ideal for Events",
                    description: "Perfect for conferences, business events, professional meetups, networking, and dating."
                )
            }
            .padding(.horizontal)
            .padding(.top, 24)
            Spacer()
        }
    }
}

struct InfoItem: View {
    var icon: String
    var title: String
    var description: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                
                Text(description)
                    .font(.system(size: 12))
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.gray)
            }
        }
    }
}
