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
    @State private var profileImage: UIImage? = nil
    @State private var pickerItem: PhotosPickerItem? = nil
    @State private var name: String = ""
    @State private var socialName: String = ""
    @State private var socialLink: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Фото профиля
                PhotosPicker(selection: $pickerItem, matching: .images) {
                    if let image = profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 260, height: 260)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 2))
                    } else {
                        Image(systemName: "person.crop.circle.dashed.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                    }
                }
                .onChange(of: pickerItem) { _, newValue in
                    guard let item = newValue else { return }
                    Task {
                        if let data = try? await item.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            profileImage = uiImage
                        }
                    }
                }
                .padding(.top, 32)
                
                // Имя пользователя
                VStack(alignment: .leading, spacing: 4) {
                    Text("Введите ваше имя")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                    TextField("Имя", text: $name)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 12)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1) // обводка
                        )
                }
                .padding(.horizontal, 24)
                
                // Соцсеть смежно с описанием
                VStack(spacing: 4) {
                    
                    Text("Введите название соцсети и ссылку на ваш профиль, чтобы люди могли найти вас.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 16) {
                        TextField("Название соцсети", text: $socialName)
                            .padding(.vertical, 12)
                            .font(.system(size: 12, weight: .regular))
                        Divider()
                            .frame(height: 40)
                            .background(Color.gray.opacity(0.5))
                        TextField("Ссылка на профиль", text: $socialLink)
                            .padding(.vertical, 12)
                            .font(.system(size: 12, weight: .regular))
                    }
                    .padding(.horizontal, 12)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(10)
                }
                .padding(16)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
