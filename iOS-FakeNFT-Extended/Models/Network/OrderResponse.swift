import Foundation

struct OrderResponse: Codable {
    let nfts: [String]
    let id: String?

    // MARK: - Инициализаторы

    init(nfts: [String], id: String?) {
        self.nfts = nfts
        self.id = id
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {
        case nfts, id
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.nfts = try container.decodeIfPresent([String].self, forKey: .nfts) ?? []
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
    }
}
