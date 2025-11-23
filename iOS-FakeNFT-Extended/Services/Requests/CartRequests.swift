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

    var httpMethod: HttpMethod = .put

    var dto: Encodable? { nil }

    func asURLRequest() throws -> URLRequest {
        guard let url = endpoint else {
            throw NetworkClientError.incorrectRequest("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        let bodyString = nfts.map { "nfts=\($0)" }.joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded; charset=utf-8",
                         forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
}

struct GetCurrenciesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
}

struct GetNFTRequest: NetworkRequest {
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
