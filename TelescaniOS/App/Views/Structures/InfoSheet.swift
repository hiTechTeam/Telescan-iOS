import SwiftUI

struct InfoSheetView: View {
    
    private let person2Fill: String = "person.2.fill"
    private let boltFill: String = "bolt.fill"
    private let lockFill: String = "lock.fill"
    private let netWork: String = "network"
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                Text(Inc.Info.Telescan)
                    .font(.system(size: 24, weight: .medium))
                    .multilineTextAlignment(.center)
                Text(Inc.Info.mainDescription.localized)
                    .font(.system(size: 12, weight: .medium))
                    .frame(maxWidth: 360)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 48)
            
            VStack(alignment: .leading, spacing: 16) {
                
                InfoItem(
                    icon: person2Fill,
                    title: Inc.Info.instantExchangeTitle.localized,
                    description: Inc.Info.instantExchangeDesc.localized
                )
                
                InfoItem(
                    icon: boltFill,
                    title: Inc.Info.fastOfflineTitle.localized,
                    description: Inc.Info.fastOfflineDesc.localized
                )
                
                InfoItem(
                    icon: lockFill,
                    title: Inc.Info.dataProtectionTitle.localized,
                    description: Inc.Info.dataProtectionDesc.localized
                )
                
                InfoItem(
                    icon: netWork,
                    title: Inc.Info.idealForEventsTitle.localized,
                    description: Inc.Info.idealForEventsDesc.localized
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
