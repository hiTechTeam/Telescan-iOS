import SwiftUI
import PhotosUI

struct ProfileData: View {
    
    @StateObject private var viewModel = CodeViewModel()
    @State private var isToggleOn: Bool = UserDefaults.standard.bool(forKey: "scanToggle")
    
    @State private var profileImage: Image = Image(systemName: "person.crop.square.on.square.angled.fill")
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var uiImage: UIImage? = nil
    
    private let innerSpacing: CGFloat = 16
    private let fontSize: CGFloat = 12
    private let fieldWidth: CGFloat = 175
    private let fieldHeight: CGFloat = 10
    private let descriptionFontSize: CGFloat = 12
    private let descriptionWidth: CGFloat = 280
    
    private var photoPickerView: some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            if uiImage == nil {
                profileImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.gray)
                    .opacity(0.5)
                    .padding(.top, 100)
                    .padding(.bottom, 40)
            } else {
                profileImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 280, height: 280)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.gray.opacity(0.5), lineWidth: 4)
                    )
                    .shadow(radius: 5)
                    .padding(.top, 80)
                    .padding(.bottom, 40)
            }
        }
        .contentShape(uiImage == nil ? AnyShape(Rectangle()) : AnyShape(Circle()))
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImg = UIImage(data: data) {
                    self.uiImage = uiImg
                    self.profileImage = Image(uiImage: uiImg)
                }
            }
        }
    }
    
    private var codeSection: some View {
        VStack(spacing: innerSpacing) {
            
            // Username + Code
            HStack {
                Text(Inc.tgUsername)
                    .font(.system(size: fontSize, weight: .regular))
                    .frame(width: fieldWidth, height: fieldHeight, alignment: .leading)
                
                Text(Inc.currentCode + (viewModel.confirmedCode ?? ""))
                    .font(.system(size: fontSize, weight: .regular))
                    .opacity(0.5)
                    .frame(width: fieldWidth, height: fieldHeight, alignment: .trailing)
            }
            
            // Используем viewModel
            UsernamePlaceholderProfile(viewModel: viewModel)
            ScanToggle(isToggleOn: $isToggleOn)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var descriptionView: some View {
        Text(Inc.profileSettingsDescription)
            .font(.system(size: descriptionFontSize, weight: .regular))
            .foregroundColor(.gray)
            .frame(width: descriptionWidth)
            .multilineTextAlignment(.center)
            .padding(.top, 40)
    }
    
    var body: some View {
        ScrollView {
            photoPickerView
            codeSection
            descriptionView
        }
        .onAppear {
            if let code = UserDefaults.standard.string(forKey: "userCode") {
                viewModel.confirmedCode = code
            }
            if let username = UserDefaults.standard.string(forKey: "username") {
                viewModel.confirmedUsername = username
            }
        }
    }
}
