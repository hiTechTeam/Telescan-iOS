
import SwiftUI
import PhotosUI

final class ProfilePhotoViewModel: ObservableObject {
    
    @Published var profileImage: Image = Image(systemName: "person.crop.square.on.square.angled.fill")
    @Published var uiImage: UIImage? = nil
    
    private let photoS3UrlKey = "photoS3Url"
    private let tgID: Int?
    
    init(tgID: Int?) {
        self.tgID = tgID
        loadPhotoIfNeeded()
    }
    
    func loadPhotoIfNeeded() {
        // Локальное фото
        if let saved = ProfileImageStorage.load() {
            uiImage = saved
            profileImage = Image(uiImage: saved)
            return
        }
        
        // Фото с S3
        guard let photoUrlString = UserDefaults.standard.string(forKey: photoS3UrlKey),
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
    
    func updateProfileImage(with newImage: UIImage?) {
        Task {
            uiImage = newImage
            
            if let uiImg = newImage {
                profileImage = Image(uiImage: uiImg)
                ProfileImageStorage.save(uiImg)
                
                guard let tgID else { return }
                do {
                    let photoURL = try await FetchService.fetch.uploadProfileImage(tgID: tgID, image: uiImg)
                    UserDefaults.standard.set(photoURL, forKey: photoS3UrlKey)
                } catch {
                    print("Failed to upload profile image:", error)
                }
            } else {
                profileImage = Image(systemName: "person.crop.square.on.square.angled.fill")
                ProfileImageStorage.delete()
                UserDefaults.standard.removeObject(forKey: photoS3UrlKey)
                // TODO: Delete Photo on server if needed
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
