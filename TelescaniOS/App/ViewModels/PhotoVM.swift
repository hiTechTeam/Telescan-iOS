import SwiftUI

final class ProfilePhotoViewModel: ObservableObject {

    @Published var profileImage: Image = Image.noPhoto
    @Published var uiImage: UIImage? = nil
    
    private let photoS3UrlKey = "photoS3Url"
    @Published var tgID: Int?
    
    init() {
        loadPhotoIfNeeded()
    }
    
    func loadPhotoIfNeeded() {
        if let saved = ProfileImageStorage.load() {
            uiImage = saved
            profileImage = Image(uiImage: saved)
            return
        }
        if let urlString = UserDefaults.standard.string(forKey: photoS3UrlKey) {
            loadPhotoFromURL(urlString)
        }
    }
    
    func setTGID(_ newTGID: Int?) {
        tgID = newTGID
        // Сбрасываем локальное фото
        uiImage = nil
        profileImage = .noPhoto
        ProfileImageStorage.delete()
        
        // Загружаем новое фото, если есть URL
        if let photoURL = UserDefaults.standard.string(forKey: photoS3UrlKey) {
            loadPhotoFromURL(photoURL)
        }
    }
    
    func loadPhotoFromURL(_ urlString: String?) {
        guard let urlString, let url = URL(string: urlString) else {
            // Нет URL — сбрасываем фото
            uiImage = nil
            profileImage = .noPhoto
            ProfileImageStorage.delete()
            return
        }
        
        Task {
            do {
                let data = try await fetchData(from: url)
                if let uiImg = UIImage(data: data) {
                    await MainActor.run {
                        self.uiImage = uiImg
                        self.profileImage = Image(uiImage: uiImg)
                        ProfileImageStorage.save(uiImg)
                    }
                }
            } catch {
                print("Failed to load photo:", error)
            }
        }
    }
    
    func updateProfileImage(with newImage: UIImage?) {
        Task {
            await MainActor.run {
                self.uiImage = newImage
            }

            guard let uiImg = newImage else {
                await MainActor.run {
                    self.profileImage = .noPhoto
                }
                ProfileImageStorage.delete()
                UserDefaults.standard.removeObject(forKey: photoS3UrlKey)
                return
            }

            await MainActor.run {
                self.profileImage = Image(uiImage: uiImg)
            }

            ProfileImageStorage.save(uiImg)

            guard let tgID else { return }

            do {
                let photoURL = try await FetchService.fetch
                    .updateProfileImage(tgID: tgID, image: uiImg)

                UserDefaults.standard.set(photoURL, forKey: photoS3UrlKey)
            } catch {
                print("Failed to upload profile image:", error)
            }
        }
    }
    
    private func fetchData(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
        return data
    }
}
