
import UIKit

struct ProfileImageStorage {
    private static let filename = "profileImage.png"
    
    private static var fileURL: URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(filename)
    }
    
    static func save(_ uiImage: UIImage) {
        guard let data = uiImage.pngData() else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
    
    static func load() -> UIImage? {
        guard let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
    
    static func delete() {
        try? FileManager.default.removeItem(at: fileURL)
    }
}
