import Combine
//
//  CartViewModel+Ext.swift
//  iOS-FakeNFT-Extended
//
import SwiftUI

extension CartViewModel {

    // Добавление NFT в корзину с исправленным телом запроса
    func addToCartWithBodyFix(_ nftId: String) async throws {
        guard !isLoading else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            // Получаем текущий заказ
            let currentOrder: OrderResponse = try await client.send(
                request: GetOrderRequest()
            )

            // Добавляем новый NFT
            var updatedNFTs = currentOrder.nfts
            if !updatedNFTs.contains(nftId) {
                updatedNFTs.append(nftId)
            }

            let updateRequest = UpdateOrderRequest(nfts: updatedNFTs)

            if let defaultClient = client as? DefaultNetworkClient {
                let _: OrderResponse = try await defaultClient.sendWithBodyFix(
                    request: updateRequest
                )
            } else {
                let _: OrderResponse = try await sendWithBodyFixFallback(
                    request: updateRequest
                )
            }

            // Обновляем локальные данные
            let nftToAdd: NFTItem = try await client.send(
                request: GetNFTRequest(id: nftId)
            )
            if !cartItems.contains(where: { $0.id == nftId }) {
                cartItems.append(nftToAdd)
                cartItemsCount = cartItems.count
                total = cartItems.reduce(0) { $0 + $1.price }
            }
        } catch {
            print("❌ [BodyFix] Ошибка при добавлении в корзину: \(error)")
            errorMessage = "Не удалось добавить NFT в корзину"
            throw error
        }
    }

    // Удаление NFT из корзины с исправленным телом запроса
    func removeFromCartWithBodyFix(_ nftId: String) async throws {
        guard !isLoading && isInCart(nftId) else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let currentOrder: OrderResponse = try await client.send(
                request: GetOrderRequest()
            )
            let updatedNFTs = currentOrder.nfts.filter { $0 != nftId }

            let updateRequest = UpdateOrderRequest(nfts: updatedNFTs)

            if let defaultClient = client as? DefaultNetworkClient {
                let _: OrderResponse = try await defaultClient.sendWithBodyFix(
                    request: updateRequest
                )
            } else {
                let _: OrderResponse = try await sendWithBodyFixFallback(
                    request: updateRequest
                )
            }

            // Обновляем локальные данные
            cartItems.removeAll { $0.id == nftId }
            cartItemsCount = cartItems.count
            total = cartItems.reduce(0) { $0 + $1.price }

        } catch {
            print("❌ [BodyFix] Ошибка при удалении из корзины: \(error)")
            errorMessage = "Не удалось удалить NFT из корзины"
            throw error
        }
    }

    private func sendWithBodyFixFallback<T: Decodable>(
        request: UpdateOrderRequest
    ) async throws -> T {
        let urlRequest = try request.asURLRequestWithProperBody()
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkClientError.urlSessionError
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkClientError.httpStatusCode(httpResponse.statusCode)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}

// MARK: - Обновление основного CartViewModel+Ext.swift
extension CartViewModel {

    // Проверка, находится ли NFT в корзине
    func isInCart(_ nftId: String) -> Bool {
        return cartItems.contains { $0.id == nftId }
    }

    // Добавление NFT в корзину - используем исправленную версию
    func addToCart(_ nftId: String) async throws {
        try await addToCartWithBodyFix(nftId)
    }

    // Удаление NFT из корзины - используем исправленную версию
    func removeFromCart(_ nftId: String) async throws {
        try await removeFromCartWithBodyFix(nftId)
    }
}
