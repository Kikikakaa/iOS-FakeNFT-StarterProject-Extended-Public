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

struct ProfileUploadDto: Encodable {
    let name: String
    let description: String
    let website: String
    let likes: [String]
    let avatar: String?
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
        
        let uploadDto = ProfileUploadDto(
            name: model.name,
            description: model.description,
            website: model.websiteURL?.absoluteString ?? "",
            likes: [],
            avatar: model.avatarURL?.absoluteString
        )
        
        let request = ProfileUpdateRequest(id: profileId, dto: uploadDto)
        
        let result: ProfileResult = try await networkClient.send(request: request)
        return convertToModel(result)
    }
    
    // Вынес конвертацию в отдельный метод, чтобы не дублировать код
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

// Запрос на получение
struct ProfileRequest: NetworkRequest {
    let id: String
    var endpoint: URL? { URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)") }
}

// Запрос на обновление (PUT)
struct ProfileUpdateRequest: NetworkRequest {
    let id: String
    let dto: Encodable? // Тело запроса
    
    var endpoint: URL? { URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)") }
    var httpMethod: HttpMethod { .put } // Метод PUT
}
