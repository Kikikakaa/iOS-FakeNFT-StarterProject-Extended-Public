//
//  CartRequests+Ext.swift
//  iOS-FakeNFT-Extended
//
import Foundation

// MARK: - Extension for proper body formatting
extension UpdateOrderRequest {

    func asURLRequestWithProperBody() throws -> URLRequest {
        guard let url = endpoint else {
            throw NetworkClientError.incorrectRequest("Invalid URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue

        let bodyString = nfts.map { "nfts=\($0)" }.joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)

        request.setValue(
            "application/x-www-form-urlencoded; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(
            RequestConstants.token,
            forHTTPHeaderField: "X-Practicum-Mobile-Token"
        )

        return request
    }
}

// MARK: - Enhanced NetworkClient for body-fixed requests
extension DefaultNetworkClient {

    func sendWithBodyFix<T: Decodable>(request: UpdateOrderRequest) async throws
        -> T
    {
        let urlRequest = try request.asURLRequestWithProperBody()

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkClientError.urlSessionError
        }

        if !(200...299).contains(httpResponse.statusCode) {
            if let responseString = String(data: data, encoding: .utf8) {
                print("🌐 [BodyFix] Тело ответа: \(responseString)")
            }
            throw NetworkClientError.httpStatusCode(httpResponse.statusCode)
        }

        do {
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        } catch {
            print("🌐 [BodyFix] Ошибка декодирования: \(error)")
            throw NetworkClientError.parsingError
        }
    }
}
