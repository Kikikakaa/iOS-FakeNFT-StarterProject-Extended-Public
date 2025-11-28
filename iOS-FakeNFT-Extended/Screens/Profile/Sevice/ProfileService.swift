import Foundation

struct ProfileResult: Decodable {
    let name: String
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [String]?
    let likes: [String]?
    let id: String
}

protocol ProfileService {
    func loadProfile() async throws -> ProfileModel
    func updateProfile(model: ProfileModel) async throws -> ProfileModel
}

final class ProfileServiceImpl: ProfileService {
    
    private let networkClient: NetworkClient
    private let profileId: String = "1"
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadProfile() async throws -> ProfileModel {
        let request = ProfileRequest(id: profileId)
        let result: ProfileResult = try await networkClient.send(request: request)
        return convertToModel(result)
    }
    
    func updateProfile(model: ProfileModel) async throws -> ProfileModel {
        // Собираем URL
        let urlString = "\(RequestConstants.baseURL)/api/v1/profile/\(profileId)"
        guard let url = URL(string: urlString) else {
            throw NetworkClientError.urlSessionError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        // Устанавливаем правильные заголовки
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        // Собираем параметры формы
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "name", value: model.name),
            URLQueryItem(name: "description", value: model.description),
            URLQueryItem(name: "website", value: model.websiteURL?.absoluteString ?? ""),
            URLQueryItem(name: "avatar", value: model.avatarURL?.absoluteString ?? "")
        ]
        
        // Кодируем тело запроса
        request.httpBody = components.percentEncodedQuery?.data(using: .utf8)
        
        // Отправляем запрос (используем URLSession напрямую для специфичного формата)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw NetworkClientError.httpStatusCode( (response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(ProfileResult.self, from: data)
        return convertToModel(result)
    }
    
    private func convertToModel(_ result: ProfileResult) -> ProfileModel {
        return ProfileModel(
            avatarURL: URL(string: result.avatar ?? ""),
            name: result.name,
            description: result.description ?? "",
            websiteURL: URL(string: result.website ?? ""),
            nftsCount: "(\(result.nfts?.count ?? 0))",
            likesCount: "(\(result.likes?.count ?? 0))"
        )
    }
}

struct ProfileRequest: NetworkRequest {
    let id: String
    var endpoint: URL? { URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)") }
}
