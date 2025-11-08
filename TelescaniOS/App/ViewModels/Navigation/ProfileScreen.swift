import SwiftUI
import PhotosUI

class ProfileStore: ObservableObject {
    @AppStorage("profileName") var name: String = ""
    @AppStorage("socialName") var socialName: String = ""
    @AppStorage("socialLink") var socialLink: String = ""
    @Published var profileImage: UIImage? = nil
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "profileImage") {
            profileImage = UIImage(data: data)
        }
    }
    
    func saveImage(_ image: UIImage) {
        profileImage = image
        if let data = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(data, forKey: "profileImage")
        }
    }
}


struct ProfileScreen: View {
    @EnvironmentObject var profileStore: ProfileStore
    @State private var pickerItem: PhotosPickerItem? = nil
    
    @State private var draftName: String = ""
    @State private var draftSocialName: String = ""
    @State private var draftSocialLink: String = ""
    
    @State private var isEditing = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                PhotosPicker(selection: $pickerItem, matching: .images) {
                    if let image = profileStore.profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 260, height: 260)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 2))
                    } else {
                        Image("PhotoProfileIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 180)
                            .foregroundColor(.gray)
                    }
                }
                .onChange(of: pickerItem) { _, newValue in
                    guard let item = newValue else { return }
                    Task {
                        if let data = try? await item.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            profileStore.saveImage(uiImage)
                        }
                    }
                }
                .padding(.top, 32)
                
                // Имя
                VStack(alignment: .leading, spacing: 4) {
                    Text("Введите ваше имя")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                    
                    TextField("Имя", text: $draftName, onEditingChanged: { editing in
                        if editing { withAnimation { isEditing = true } }
                    })
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 24)
                
                
                VStack(spacing: 4) {
                    Text("Введите название соцсети и никнейм, чтобы люди могли найти вас.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 12) {
                        
                        TextField("Соцсеть", text: $draftSocialName, onEditingChanged: { editing in
                            if editing { withAnimation { isEditing = true } }
                        })
                        .font(.system(size: 12))
                        
                        Divider()
                            .frame(height: 24)
                            .background(Color.gray.opacity(0.5))
                        
                        TextField("Никнейм", text: $draftSocialLink, onEditingChanged: { editing in
                            if editing { withAnimation { isEditing = true } }
                        })
                        .font(.system(size: 12))
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(10)
                    .frame(maxWidth: 360)
                }
                .padding(16)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
        .navigationTitle(isEditing ? "" : "Профиль")
        .navigationBarTitleDisplayMode(.inline) // именно это делает заголовок маленьким
        .toolbar {
            if isEditing {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        draftName = profileStore.name
                        draftSocialName = profileStore.socialName
                        draftSocialLink = profileStore.socialLink
                        withAnimation { isEditing = false }
                        hideKeyboard()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        profileStore.name = draftName
                        profileStore.socialName = draftSocialName
                        profileStore.socialLink = draftSocialLink
                        withAnimation { isEditing = false }
                        hideKeyboard()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            draftName = profileStore.name
            draftSocialName = profileStore.socialName
            draftSocialLink = profileStore.socialLink
        }
        .onTapGesture { hideKeyboard() }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
