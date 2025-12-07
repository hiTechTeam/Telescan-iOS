import SwiftUI
import PhotosUI

// MARK: - Profile Data View
@MainActor
struct ProfileDataView: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    @ObservedObject var authCodeViewModel: CodeViewModel
    
    private let userCodeKey: String = "userCode"
    private let usernameKey: String = "username"
    
    var body: some View {
        ZStack {
            Color.tsBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    ProfilePhotoView(authCodeViewModel: authCodeViewModel)
                    
                    VStack(spacing: 16) {
                        HStack {
                            Text(Inc.Registration.tgUsername)
                                .font(.system(size: 12))
                                .frame(width: 175, alignment: .leading)
                            
                            Text(Inc.Registration.currentCode.localized + (authCodeViewModel.confirmedCode ?? ""))
                                .font(.system(size: 12))
                                .opacity(0.5)
                                .frame(width: 175, alignment: .trailing)
                        }
                        
                        UsernamePlaceholderProfile(viewModel: authCodeViewModel)
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
            if let code = UserDefaults.standard.string(forKey: userCodeKey) {
                authCodeViewModel.confirmedCode = code
            }
            
            if let username = UserDefaults.standard.string(forKey: usernameKey) {
                authCodeViewModel.confirmedUsername = username
            }
        }
    }
}

// MARK: - Profile Photo View
@MainActor
struct ProfilePhotoView: View {
    
    @ObservedObject var authCodeViewModel: CodeViewModel
    
    @State private var profileImage: Image = Image(systemName: "person.crop.square.on.square.angled.fill")
    @State private var uiImage: UIImage? = nil
    @State private var selectedItem: PhotosPickerItem? = nil
    
    @State private var showPhotoOptions: Bool = false
    @State private var showCameraPicker: Bool = false
    @State private var showGalleryPicker: Bool = false
    
    private let imageSizeEmpty: CGFloat = 120
    private let imageSizeFilled: CGFloat = 280
    private let photoS3UrlKey: String = "photoS3Url"
    
    var body: some View {
        Group {
            if let _ = uiImage {
                profileImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageSizeFilled, height: imageSizeFilled)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 4))
                    .shadow(radius: 5)
            } else {
                profileImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSizeEmpty, height: imageSizeEmpty)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 40)
        .onTapGesture { showPhotoOptions = true }
        .onChange(of: authCodeViewModel.photoS3URL) { _, _ in
            loadPhotoIfNeeded()
        }
        .onAppear {
            loadPhotoIfNeeded()
        }
        .confirmationDialog(Inc.Profile.photoOptions.localized, isPresented: $showPhotoOptions) {
            Button(Inc.Profile.takePhoto.localized) {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    showCameraPicker = true
                }
            }
            
            Button(Inc.Profile.galleryPhoto.localized) {
                showGalleryPicker = true
            }
            
            if uiImage != nil {
                Button(Inc.Profile.deletePhoto.localized, role: .destructive) {
                    uiImage = nil
                    updateProfileImage()
                }
            }
            
            Button(Inc.Common.cancel.localized, role: .cancel) {}
        }
        .fullScreenCover(isPresented: $showCameraPicker) {
            CameraPicker(image: $uiImage)
                .edgesIgnoringSafeArea(.all)
                .onDisappear {
                    updateProfileImage()
                }
        }
        .photosPicker(
            isPresented: $showGalleryPicker,
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
        )
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImg = UIImage(data: data) {
                    uiImage = uiImg
                    updateProfileImage()
                }
            }
        }
    }
    
    // MARK: - Image Loading & Updating
    private func loadPhotoIfNeeded() {
        // Локальное фото
        if let saved = ProfileImageStorage.load() {
            uiImage = saved
            profileImage = Image(uiImage: saved)
            return
        }
        
        // Фото с S3
        guard let photoUrlString = authCodeViewModel.photoS3URL ?? UserDefaults.standard.string(forKey: photoS3UrlKey),
              let url = URL(string: photoUrlString) else { return }
        
        Task { @MainActor in
            do {
                let data = try await fetchData(from: url)
                if let uiImg = UIImage(data: data) {
                    uiImage = uiImg
                    profileImage = Image(uiImage: uiImg)
                    ProfileImageStorage.save(uiImg)
                }
            } catch {
                print("Failed to load photo from S3:", error)
            }
        }
    }
    
    private func updateProfileImage() {
        Task { @MainActor in
            if let uiImg = uiImage {
                profileImage = Image(uiImage: uiImg)
                ProfileImageStorage.save(uiImg)
                
                guard let tgID = authCodeViewModel.tgId else { return }
                
                do {
                    let photoURL = try await FetchService.fetch.uploadProfileImage(tgID: tgID, image: uiImg)
                    UserDefaults.standard.set(photoURL, forKey: photoS3UrlKey)
                    authCodeViewModel.photoS3URL = photoURL
                } catch {
                    print("Failed to upload profile image:", error)
                }
            } else {
                profileImage = Image(systemName: "person.crop.square.on.square.angled.fill")
                ProfileImageStorage.delete()
                UserDefaults.standard.removeObject(forKey: photoS3UrlKey)
                authCodeViewModel.photoS3URL = nil
                
                guard let tgID = authCodeViewModel.tgId else { return }
                
                do {
                    try await FetchService.fetch.deleteProfileImage(tgID: tgID)
                } catch {
                    print("Failed to delete photo on server:", error)
                }
            }
        }
    }
    
    private func fetchData(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}
