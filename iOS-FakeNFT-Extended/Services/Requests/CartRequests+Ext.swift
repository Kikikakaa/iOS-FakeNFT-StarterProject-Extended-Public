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
        
        // Правильный формат тела: каждый NFT как отдельный параметр nfts
        // Результат: nfts=id1&nfts=id2&nfts=id3
        let bodyString = nfts.map { "nfts=\($0)" }.joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        // Диагностика
        print("📦 [BodyFix] Тело запроса: \(bodyString)")
        print("📦 [BodyFix] Количество NFT: \(nfts.count)")
        print("📦 [BodyFix] Заголовки: \(request.allHTTPHeaderFields ?? [:])")
        
        return request
    }
}

// MARK: - Enhanced NetworkClient for body-fixed requests
extension DefaultNetworkClient {
    
    func sendWithBodyFix<T: Decodable>(request: UpdateOrderRequest) async throws -> T {
        let urlRequest = try request.asURLRequestWithProperBody()
        
        print("🌐 [BodyFix] Отправка: \(urlRequest.url?.absoluteString ?? "nil")")
        print("🌐 [BodyFix] Метод: \(urlRequest.httpMethod ?? "GET")")
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("🌐 [BodyFix] Ошибка: неверный ответ")
            throw NetworkClientError.urlSessionError
        }
        
        print("🌐 [BodyFix] Получен ответ: статус \(httpResponse.statusCode)")
        
        if !(200...299).contains(httpResponse.statusCode) {
            print("🌐 [BodyFix] Ошибка HTTP: \(httpResponse.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("🌐 [BodyFix] Тело ответа: \(responseString)")
            }
            throw NetworkClientError.httpStatusCode(httpResponse.statusCode)
        }
        
        do {
            let decoded = try decoder.decode(T.self, from: data)
            print("🌐 [BodyFix] Успешно декодирован ответ")
            return decoded
        } catch {
            print("🌐 [BodyFix] Ошибка декодирования: \(error)")
            throw NetworkClientError.parsingError
        }
    }
}

