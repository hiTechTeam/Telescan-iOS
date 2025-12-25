import SwiftUI

struct InfoSheetView: View {
    
    // MARK: - Constants
    private let boltFill = "bolt.fill"
    private let lockFill = "lock.fill"
    private let netWork = "network"
    
    private let boxWidth: CGFloat = 360
    private let boxHeight: CGFloat = 52
    private let cornerRadius: CGFloat = 13
    
    private let githubURL = URL(string: "https://github.com/orgs/hiTechTeam/repositories")!
    private let githubURLString = "https://github.com/orgs/hiTechTeam/repositories"
    
    // MARK: - Components
    private var headerSection: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                Text(Inc.Info.Telescan)
                    .font(.system(size: 24, weight: .medium))
                    .multilineTextAlignment(.center)
                
                Text(Inc.Info.mainDescription.localized)
                    .font(.system(size: 12, weight: .medium))
                    .multilineTextAlignment(.center)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                InfoItem(
                    icon: boltFill,
                    title: Inc.Info.instantExchangeTitle.localized,
                    description: Inc.Info.instantExchangeDesc.localized
                )
                
                Divider()
                
                InfoItem(
                    icon: lockFill,
                    title: Inc.Info.dataProtectionTitle.localized,
                    description: Inc.Info.dataProtectionDesc.localized
                )
                
                Divider()
                
                InfoItem(
                    icon: netWork,
                    title: Inc.Info.idealForEventsTitle.localized,
                    description: Inc.Info.idealForEventsDesc.localized
                )
            }
        }
    }
    
    private var openSourceSection: some View {
        VStack {
            HStack(spacing: 12) {
                Image.tsIconGraySmall
                    .resizable()
                    .frame(width: 24, height: 25)
                
                Text(Inc.Info.version.localized + Inc.Info.currentVersion)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: boxWidth, alignment: .center)
            
            Divider()
            
            Link(githubURLString, destination: githubURL)
                .font(.system(size: 12, weight: .medium))
                .frame(width: boxWidth, height: boxHeight, alignment: .center)
        }
    }
    
    private var listContent: some View {
        List {
            Section { headerSection }
            
            Section(
                header: Text(Inc.Info.openSourceText.localized)
                    .font(.system(size: 12))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray),
                footer: Text(Inc.Info.licenseMIT.localized)
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(.gray)
                    .frame(width: boxWidth, alignment: .center)
            ) {
                openSourceSection
            }
        }
        .listStyle(.insetGrouped)
    }
    
    // MARK: - Body
    var body: some View {
        listContent
    }
}

struct InfoItem: View {
    
    var icon: String
    var title: String
    var description: String
    
    private var content: some View {
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
    
    // MARK: - Body
    var body: some View {
        content
    }
}
