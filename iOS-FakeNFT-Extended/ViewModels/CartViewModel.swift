import Foundation
import Combine

@MainActor
final class CartViewModel: ObservableObject {
    @Published var cartItems: [NFTItem] = []
    @Published var cartItemsCount: Int = 0
    @Published var total: Double = 0.0
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let client = DefaultNetworkClient()
    private let orderId = "1"

    func loadCart() async {
        isLoading = true
        errorMessage = nil

        do {
            // 1. Получаем корзину
            let order: OrderResponse = try await client.send(request: GetOrderRequest())

            // 2. Загружаем NFT параллельно
            let nftItems = try await withThrowingTaskGroup(of: NFTItem.self) { group in
                for nftId in order.nfts {
                    group.addTask {
                        try await self.client.send(request: GetNFTRequest(id: nftId))
                    }
                }
                var results: [NFTItem] = []
                for try await nft in group {
                    results.append(nft)
                }
                return results
            }

            // 3. Сохраняем порядок из корзины
            self.cartItems = order.nfts.compactMap { id in
                nftItems.first { $0.id == id }
            }
            self.cartItemsCount = cartItems.count
            // 4. Считаем total
            self.total = cartItems.reduce(0) { $0 + $1.price }

        } catch {
            errorMessage = "Ошибка: \(error.localizedDescription)"
            print("Cart error: \(error)")
        }

        isLoading = false
    }

    func removeItem(_ nftId: String) async {
        guard let index = cartItems.firstIndex(where: { $0.id == nftId }) else { return }

        isLoading = true

        do {
            let updatedNFTs = cartItems.filter { $0.id != nftId }.map { $0.id }
            let _: OrderResponse = try await client.send(
                request: UpdateOrderRequest(nfts: updatedNFTs)
            )

            cartItems.remove(at: index)
            self.cartItemsCount = cartItems.count
            total = cartItems.reduce(0) { $0 + $1.price }

        } catch {
            errorMessage = "Не удалось удалить"
        }

        isLoading = false
    }

    func clearCart() async {
        isLoading = true
        do {
            let _: OrderResponse = try await client.send(
                request: UpdateOrderRequest(nfts: [])
            )
            cartItems = []
            cartItemsCount = 0
            total = 0
        } catch {
            errorMessage = "Ошибка очистки"
        }
        isLoading = false
    }
}

extension CartViewModel {
    enum ViewState {
        case loading
        case error(String)
        case empty
        case content(items: [NFTItem], total: Double)
    }

    var state: ViewState {
        if isLoading {
            return .loading
        } else if let error = errorMessage {
            return .error(error)
        } else if cartItems.isEmpty {
            return .empty
        } else {
            return .content(items: cartItems, total: total)
        }
    }
}
