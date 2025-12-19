
import SwiftUI
import PhotosUI

struct ProfilePhotoView: View {
    
    @ObservedObject var authCodeViewModel: CodeViewModel
    
    @State private var profileImage: Image = Image(systemName: "person.crop.square.on.square.angled.fill")
    @State private var uiImage: UIImage? = nil
    @State private var selectedItem: PhotosPickerItem? = nil
    
    @State private var showPhotoOptions: Bool = false
    @State private var showCameraPicker: Bool = false
    @State private var showGalleryPicker: Bool = false
    @State private var isPreviewing = false
    
    private let imageSizeEmpty: CGFloat = 120
    private let imageSizeFilled: CGFloat = 250
    private let photoS3UrlKey: String = "photoS3Url"
    
    var body: some View {
        ZStack {
        
            Group {
                if let _ = uiImage {
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSizeFilled, height: imageSizeFilled)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .strokeBorder(Color.primary.opacity(0.5), lineWidth: 4)
                                .padding(-4)
                                .opacity(0.5)
                        )
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
            .onLongPressGesture(
                pressing: { pressing in
                    isPreviewing = pressing
                },
                perform: {}
            )
            
            // fullscreen preview
            if isPreviewing, let uiImage {
                ZStack {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 390, height: 390)
                        .padding(.vertical, 20)
                        .clipShape(Circle())
                        .shadow(radius: 20)
                }
                .transition(.opacity)
                .zIndex(10)
            }
        }
        .onChange(of: authCodeViewModel.PhotoS3URL) { _, _ in
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
                .onDisappear { updateProfileImage() }
        }
        .photosPicker(
            isPresented: $showGalleryPicker,
            selection: $selectedItem,
            matching: .images
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
        guard let photoUrlString = authCodeViewModel.PhotoS3URL ?? UserDefaults.standard.string(forKey: photoS3UrlKey),
              let url = URL(string: photoUrlString) else { return }
        
        Task {
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
        Task {
            if let uiImg = uiImage {
                profileImage = Image(uiImage: uiImg)
                ProfileImageStorage.save(uiImg)
                
                guard let tgID = authCodeViewModel.tgID else { return }
                
                do {
                    let photoURL = try await FetchService.fetch.uploadProfileImage(tgID: tgID, image: uiImg)
                    UserDefaults.standard.set(photoURL, forKey: photoS3UrlKey)
                    authCodeViewModel.PhotoS3URL = photoURL
                } catch {
                    print("Failed to upload profile image:", error)
                }
            } else {
                profileImage = Image(systemName: "person.crop.square.on.square.angled.fill")
                ProfileImageStorage.delete()
                UserDefaults.standard.removeObject(forKey: photoS3UrlKey)
                authCodeViewModel.PhotoS3URL = nil
                
                // TODO: Delete Photo in device and server
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
