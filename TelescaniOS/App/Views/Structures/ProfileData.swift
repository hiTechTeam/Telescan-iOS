import SwiftUI
import PhotosUI

struct ProfileData: View {
    
    @StateObject private var viewModel = CodeViewModel()
    @State private var isToggleOn: Bool = UserDefaults.standard.bool(forKey: "scanToggle")
    
    @State private var profileImage: Image = Image(systemName: imageFill)
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var uiImage: UIImage? = nil
    
    @State private var showPhotoOptions: Bool = false
    @State private var showCameraPicker: Bool = false
    @State private var showGalleryPicker: Bool = false
    
    private static let imageFill: String = "person.crop.square.on.square.angled.fill"
    
    private let imageSizeEmpty: CGFloat = 120
    private let imageSizeFilled: CGFloat = 280
    private let userCodeKey: String = "userCode"
    private let usernameKey: String = "username"
    private let takePhoto: String = "Take Photo"
    
    private var profileImageView: some View {
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
    }
    private var codeSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text(Inc.tgUsername)
                    .font(.system(size: 12))
                    .frame(width: 175, alignment: .leading)
                Text(Inc.currentCode + (viewModel.confirmedCode ?? ""))
                    .font(.system(size: 12))
                    .opacity(0.5)
                    .frame(width: 175, alignment: .trailing)
            }
            UsernamePlaceholderProfile(viewModel: viewModel)
            ScanToggle(isToggleOn: $isToggleOn)
        }
        .frame(maxWidth: .infinity)
    }
    private var descriptionView: some View {
        Text(Inc.profileSettingsDescription)
            .font(.system(size: 12))
            .foregroundColor(.gray)
            .frame(width: 280)
            .multilineTextAlignment(.center)
            .padding(.top, 40)
    }
    
    private func updateProfileImage() {
        if let uiImg = uiImage {
            profileImage = Image(uiImage: uiImg)
            ProfileImageStorage.save(uiImg)
        } else {
            ProfileImageStorage.delete()
            profileImage = Image(systemName: ProfileData.imageFill)
        }
    }
    
    var body: some View {
        ZStack {
            Color.tsBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    profileImageView
                        .onTapGesture { showPhotoOptions = true }
                    codeSection
                    descriptionView
                }
            }
        }
        .onAppear {
            
            if let saved = ProfileImageStorage.load() {
                uiImage = saved
                profileImage = Image(uiImage: saved)
            }
            
            
            if let code = UserDefaults.standard.string(forKey: userCodeKey) {
                viewModel.confirmedCode = code
            }
            if let username = UserDefaults.standard.string(forKey: usernameKey) {
                viewModel.confirmedUsername = username
            }
        }
        .confirmationDialog(Inc.photoOptions, isPresented: $showPhotoOptions) {
            
            Button(Inc.takePhoto) {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    showCameraPicker = true
                }
            }
            
            Button(Inc.galleryPhoto) {
                showGalleryPicker = true
            }
            
            if uiImage != nil {
                Button(Inc.deletePhoto, role: .destructive) {
                    uiImage = nil
                    updateProfileImage()
                }
            }
            
            Button(Inc.cancel, role: .cancel) {}
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
    
    
}
