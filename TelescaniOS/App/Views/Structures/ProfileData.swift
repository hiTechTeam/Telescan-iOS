import SwiftUI

struct ProfileDataView: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    @ObservedObject var authCodeViewModel: CodeViewModel
    @StateObject private var photoVM = ProfilePhotoViewModel()
    
    init(authCodeViewModel: CodeViewModel) {
        self.authCodeViewModel = authCodeViewModel
    }
    
    private var headerInfo: some View {
        VStack(spacing: 8) {
            HStack {
                Text(Inc.Registration.tgUsername)
                    .font(.system(size: 12))
                    .frame(width: 175, alignment: .leading)
                
                Text(Inc.Registration.currentCode.localized + authCodeViewModel.code)
                    .font(.system(size: 12))
                    .opacity(0.5)
                    .frame(width: 175, alignment: .trailing)
            }
            
            UsernamePlaceholderProfile(authVM: authCodeViewModel)
        }
    }
    
    private var profileSection: some View {
        VStack(spacing: 16) {
            ProfilePhotoView(viewModel: photoVM)
            headerInfo
            ScanToggle(isScaning: $coordinator.isScaning)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var descriptionText: some View {
        Text(Inc.Profile.profileSettingsDescription.localized)
            .font(.system(size: 12))
            .foregroundColor(.gray)
            .frame(width: 280)
            .multilineTextAlignment(.center)
            .padding(.top, 40)
    }
    
    private var scrollContent: some View {
        ScrollView {
            VStack {
                profileSection
                descriptionText
            }
        }
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.tsBackground
                .ignoresSafeArea()
            scrollContent
        }
        .onChange(of: authCodeViewModel.photoS3URL) { _, newValue in
            photoVM.loadPhotoFromURL(newValue)
        }
    }
}
