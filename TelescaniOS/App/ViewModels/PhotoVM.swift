import SwiftUI

final class ProfilePhotoViewModel: ObservableObject {
    
    @Published var profileImage: Image = .noPhoto
    @Published var uiImage: UIImage?
    
    private let photoS3UrlKey = "photoS3Url"
    @Published var tgID: Int?
    
    init() {
        if let storedTGID = UserDefaults.standard.object(forKey: Keys.tgIdKey.rawValue) as? Int {
            self.tgID = storedTGID
        }
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
        
        guard tgID != newTGID else { return }
        
        tgID = newTGID
        if let newTGID {
            UserDefaults.standard.set(newTGID, forKey: Keys.tgIdKey.rawValue)
        }
        
        uiImage = nil
        profileImage = .noPhoto
        ProfileImageStorage.delete()
        
        loadPhotoIfNeeded()
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
            guard let tgID else { return }
            
            // Remove photo
            guard let originalImage = newImage else {
                await MainActor.run {
                    self.uiImage = nil
                    self.profileImage = .noPhoto
                }
                
                ProfileImageStorage.delete()
                UserDefaults.standard.removeObject(forKey: photoS3UrlKey)
                try? await FetchService.fetch.deleteProfileImage(tgID: tgID)
                return
            }
            
            // Resize + compress
            let resizedImage = originalImage.resized(maxSide: 1024)
            
            guard let compressedData = resizedImage.compressed(quality: 0.65),
                  let compressedUIImage = UIImage(data: compressedData)
            else {
                return
            }
            
            await MainActor.run {
                self.uiImage = compressedUIImage
                self.profileImage = Image(uiImage: compressedUIImage)
            }
            
            ProfileImageStorage.save(compressedUIImage)
            
            do {
                let photoURL = try await FetchService.fetch
                    .updateProfileImage(tgID: tgID, image: compressedUIImage)
                
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


extension UIImage {
    
    /// Resize image keeping aspect ratio
    func resized(maxSide: CGFloat) -> UIImage {
        let maxCurrentSide = max(size.width, size.height)
        guard maxCurrentSide > maxSide else { return self }
        
        let scale = maxSide / maxCurrentSide
        let newSize = CGSize(
            width: size.width * scale,
            height: size.height * scale
        )
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    /// JPEG compression
    func compressed(quality: CGFloat = 0.65) -> Data? {
        jpegData(compressionQuality: quality)
    }
}
