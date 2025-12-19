import SwiftUI

struct ProfileDataView: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    @ObservedObject var authCodeViewModel: CodeViewModel
    @StateObject private var photoVM = ProfilePhotoViewModel()
    
    init(authCodeViewModel: CodeViewModel) {
        self.authCodeViewModel = authCodeViewModel
    }
    
    var body: some View {
        ZStack {
            Color.tsBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    ProfilePhotoView(viewModel: photoVM)
                    
                    VStack(spacing: 16) {
                        VStack(spacing: 8) {
                            HStack {
                                Text(Inc.Registration.tgUsername)
                                    .font(.system(size: 12))
                                    .frame(width: 175, alignment: .leading)
                                
                                Text(Inc.Registration.currentCode.localized + (authCodeViewModel.Code))
                                    .font(.system(size: 12))
                                    .opacity(0.5)
                                    .frame(width: 175, alignment: .trailing)
                            }
                            UsernamePlaceholderProfile(authVM: authCodeViewModel)
                        }
                        
                        ScanToggle(isScaning: $coordinator.isScaning)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Text(Inc.Profile.profileSettingsDescription.localized)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .frame(width: 280)
                        .multilineTextAlignment(.center)
                        .padding(.top, 40)
                }
            }
        }
        .onAppear {
            photoVM.setTGID(authCodeViewModel.tgID)
        }
        .onChange(of: authCodeViewModel.tgID) { _, newValue in
            photoVM.setTGID(newValue)
        }
        .onChange(of: authCodeViewModel.PhotoS3URL) { _, newValue in
            photoVM.loadPhotoFromURL(newValue)
        }
    }
}
