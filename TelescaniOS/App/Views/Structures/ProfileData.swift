import SwiftUI
import PhotosUI

// MARK: - Camera Picker Wrapper
struct CameraPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker
        
        init(_ parent: CameraPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - Profile View
struct ProfileData: View {
    
    @StateObject private var viewModel = CodeViewModel()
    @State private var isToggleOn: Bool = UserDefaults.standard.bool(forKey: "scanToggle")
    
    @State private var profileImage: Image = Image(systemName: "person.crop.square.on.square.angled.fill")
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var uiImage: UIImage? = nil
    
    @State private var showPhotoOptions: Bool = false
    @State private var showCameraPicker: Bool = false
    @State private var showGalleryPicker: Bool = false
    
    private let imageSizeEmpty: CGFloat = 120
    private let imageSizeFilled: CGFloat = 280
    
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
            if let code = UserDefaults.standard.string(forKey: "userCode") {
                viewModel.confirmedCode = code
            }
            if let username = UserDefaults.standard.string(forKey: "username") {
                viewModel.confirmedUsername = username
            }
        }
        .confirmationDialog("Photo Options", isPresented: $showPhotoOptions) {
            Button("Take Photo") {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    showCameraPicker = true
                }
            }
            Button("Choose from Gallery") {
                showGalleryPicker = true
            }
            if uiImage != nil {
                Button("Delete Photo", role: .destructive) {
                    uiImage = nil
                    profileImage = Image(systemName: "person.crop.square.on.square.angled.fill")
                }
            }
            Button("Cancel", role: .cancel) {}
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
    
    // MARK: - Profile Image View
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
    
    // MARK: - Code Section
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
    
    // MARK: - Description
    private var descriptionView: some View {
        Text(Inc.profileSettingsDescription)
            .font(.system(size: 12))
            .foregroundColor(.gray)
            .frame(width: 280)
            .multilineTextAlignment(.center)
            .padding(.top, 40)
    }
    
    // MARK: - Helper
    private func updateProfileImage() {
        if let uiImg = uiImage {
            profileImage = Image(uiImage: uiImg)
        } else {
            profileImage = Image(systemName: "person.crop.square.on.square.angled.fill")
        }
    }
}
