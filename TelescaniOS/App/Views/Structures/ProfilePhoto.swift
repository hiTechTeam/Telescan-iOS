import SwiftUI
import PhotosUI

struct ProfilePhotoView: View {
    
    @ObservedObject var viewModel: ProfilePhotoViewModel
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var showPhotoOptions: Bool = false
    @State private var showCameraPicker: Bool = false
    @State private var showGalleryPicker: Bool = false
    @State private var isPreviewing = false
    
    private let imageSizeEmpty: CGFloat = 120
    private let imageSizeFilled: CGFloat = 240
    
    var body: some View {
        ZStack {
            Group {
                if let uiImage = viewModel.uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSizeFilled, height: imageSizeFilled)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .strokeBorder(Color.primary.opacity(0.3), lineWidth: 4)
                                .padding(-4)
                                .opacity(0.5)
                        )
                        .shadow(radius: 5)
                } else {
                    viewModel.profileImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageSizeEmpty, height: imageSizeEmpty)
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 40)
            .onTapGesture { showPhotoOptions = true }
            .onLongPressGesture(pressing: { pressing in
                isPreviewing = pressing
            }) {}
            
            if isPreviewing, let uiImage = viewModel.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 390, height: 390)
                    .clipShape(Circle())
                    .shadow(radius: 20)
                    .transition(.opacity)
                    .zIndex(10)
            }
        }
        .confirmationDialog(Inc.Profile.photoOptions.localized, isPresented: $showPhotoOptions) {
            
            Button(Inc.Profile.takePhoto.localized) {
                showCameraPicker = UIImagePickerController.isSourceTypeAvailable(.camera)
            }
            
            Button(Inc.Profile.galleryPhoto.localized) { showGalleryPicker = true }
            
            if viewModel.uiImage != nil {
                Button(Inc.Profile.deletePhoto.localized, role: .destructive) {
                    viewModel.updateProfileImage(with: nil)
                }
            }
            
            Button(Inc.Common.cancel.localized, role: .cancel) {}
        }
        .fullScreenCover(isPresented: $showCameraPicker) {
            CameraPicker(image: $viewModel.uiImage)
                .onDisappear { viewModel.updateProfileImage(with: viewModel.uiImage) }
        }
        .photosPicker(isPresented: $showGalleryPicker, selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImg = UIImage(data: data) {
                    viewModel.updateProfileImage(with: uiImg)
                }
            }
        }
    }
}
