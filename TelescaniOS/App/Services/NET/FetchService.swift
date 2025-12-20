import Foundation
import CryptoKit
import PhotosUI

//@MainActor
final class FetchService {
    
    // MARK: - Singleton
    static let fetch = FetchService()
    
    private init() {}
    
    private let POST: String = "POST"
    private let formatJSON: String = "application/json"
    private let contentType: String = "Content-Type"
    
    private let at: String = "@"
    private let hashedCode: String = "hashed_code"
    private let hexoFormat: String = "%02x"
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: hexoFormat, $0) }.joined()
    }
    
    private func _fetch<T: Decodable>(
        url: URL,
        method: String = HTTPMethods.GET.rawValue,
        queryItems: [URLQueryItem]? = nil,
        headers: [String: String]? = nil,
        body: Data? = nil
    ) async throws -> T {
        
        var components = URLComponents(string: url.absoluteString)
        if let queryItems = queryItems {
            components?.queryItems = queryItems
        }
        
        guard let finalURL = components?.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method
        
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let body = body, method != HTTPMethods.GET.rawValue {
            request.httpBody = body
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            if let str = String(data: data, encoding: .utf8) {
                print("Server response error:", str)
            }
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func fetchUserDataByHashedCode(for code: String) async throws -> GetUserDataByHashedCodeResponse {
        let hashedCodeData = sha256(code)
        
        var components = URLComponents(string: Links.telescanApiTunnel)
        components?.queryItems = [
            URLQueryItem(name: hashedCode, value: hashedCodeData)
        ]
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        let json: GetUserDataByHashedCodeResponse = try await _fetch(
            url: url,
            method: HTTPMethods.GET.rawValue
        )
        
        let responseData = GetUserDataByHashedCodeResponse(
            tg_id: json.tg_id,
            tg_name: json.tg_name,
            tg_username: json.tg_username != nil ? (at + json.tg_username!) : nil,
            photoS3URL: json.photoS3URL,
            hashedCode: hashedCodeData
        )
        
        return responseData
    }
    
    func fetchUserDataByTGID(for tgID: Int) async throws -> GetUserDataByTGID {
        
        var components = URLComponents(string: Links.telescanApiGetuser)
        components?.queryItems = [
            URLQueryItem(name: Keys.tgIdKey.rawValue, value: String(tgID))
        ]
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        let json: GetUserDataByHashedCodeResponse = try await _fetch(
            url: url,
            method: HTTPMethods.GET.rawValue
        )
        
        let responseData = GetUserDataByTGID(
            tg_name: json.tg_name,
            tg_username: json.tg_username != nil ? ("@" + json.tg_username!) : nil,
            photoS3URL: json.photoS3URL
        )
        
        return responseData
    }
    
//    func uploadProfileImage(tgID: Int, image: UIImage) async throws -> String {
//        
//        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
//            throw NSError(domain: "encode_error", code: 0)
//        }
//        
//        let body = UploadProfileImageRequest(tg_id: tgID, img: imageData.base64EncodedString())
//        let bodyData = try JSONEncoder().encode(body)
//        
//        guard let url = URL(string: Links.telescanApiUploadPhoto) else {
//            throw URLError(.badURL)
//        }
//        
//        let decoded: UploadProfileImageResponse = try await _fetch(
//            url: url,
//            method: HTTPMethods.POST.rawValue,
//            headers: ["Content-Type": "application/json"],
//            body: bodyData
//        )
//        
//        return decoded.photoS3URL
//    }
    
    func updateProfileImage(tgID: Int, image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
            throw NSError(domain: "encode_error", code: 0)
        }
        
        let body = UploadProfileImageRequest(tg_id: tgID, img: imageData.base64EncodedString())
        let bodyData = try JSONEncoder().encode(body)
        
        guard let url = URL(string: Links.telescanApiUpdatePhoto) else {
            throw URLError(.badURL)
        }
        
        let decoded: UploadProfileImageResponse = try await _fetch(
            url: url,
            method: HTTPMethods.POST.rawValue,
            headers: ["Content-Type": "application/json"],
            body: bodyData
        )
        
        return decoded.photoS3URL
    }
    
    func deleteProfileImage(tgID: Int) async throws {
        let body = UpdateUserPhotoRequestByTGID(
            tg_id: tgID,
            img: nil
        )

        let bodyData = try JSONEncoder().encode(body)

        guard let url = URL(string: Links.telescanApiUpdatePhoto) else {
            throw URLError(.badURL)
        }

        let _: UploadProfileImageResponse = try await _fetch(
            url: url,
            method: HTTPMethods.POST.rawValue,
            headers: ["Content-Type": "application/json"],
            body: bodyData
        )
    }
    
}
