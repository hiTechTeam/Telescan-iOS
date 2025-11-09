import SwiftUI
import PhotosUI

struct ProfileScreen: View {
    @EnvironmentObject var profileStore: ProfileStore
    @State private var pickerItem: PhotosPickerItem? = nil
    
    @State private var draftSocialName: String = ""
    @State private var draftSocialLink: String = ""
    
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
                
                VStack(spacing: 4) {
                    
                    HStack(spacing: 12) {
                        TextField("Соцсеть", text: $draftSocialName)
                            .onChange(of: draftSocialName) { _, newValue in
                                profileStore.socialName = newValue
                            }
                            .font(.system(size: 12))
                        
                        Divider()
                            .frame(height: 24)
                            .background(Color.gray.opacity(0.5))
                        
                        TextField("Никнейм", text: $draftSocialLink)
                            .onChange(of: draftSocialLink) { _, newValue in
                                profileStore.socialLink = newValue
                            }
                            .font(.system(size: 12))
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(10)
                    .frame(maxWidth: 360)
                    
                    Spacer()
                    
                    Text("Введите название соцсети и никнейм, чтобы люди могли найти вас.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                        .multilineTextAlignment(.center)
                }
                .padding(16)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal, 24)
                
            }
        }
        .navigationTitle("Профиль")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            
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


