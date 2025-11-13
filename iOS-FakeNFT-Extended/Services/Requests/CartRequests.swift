import Foundation

// MARK: - DTO для PUT /orders/1
struct UpdateOrderDTO: Codable {
    let nfts: [String]
}

// MARK: - NetworkRequest для корзины
struct GetOrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}

struct UpdateOrderRequest: NetworkRequest {
    let nfts: [String]

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    var httpMethod: HttpMethod { .put }

    var dto: Encodable? {
        UpdateOrderDTO(nfts: nfts)
    }
}

struct GetNFTRequest: NetworkRequest {
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
