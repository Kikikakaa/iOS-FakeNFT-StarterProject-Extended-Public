import Foundation
import Combine

@MainActor
final class CartViewModel: ObservableObject {
    @Published var cartItems: [NFTItem] = []
    @Published var cartItemsCount: Int = 0
    @Published var total: Double = 0.0
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var sortOption: SortOption? = nil

    private let client = DefaultNetworkClient()
    private let orderId = "1"

    func loadCart() async {
        isLoading = true
        errorMessage = nil

        do {

            let order: OrderResponse = try await client.send(request: GetOrderRequest())

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

            self.cartItems = order.nfts.compactMap { id in
                nftItems.first { $0.id == id }
            }
            self.cartItemsCount = cartItems.count

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
        defer { isLoading = false }

        do {
            let remainingIds = cartItems.filter { $0.id != nftId }.map { $0.id }
            let bodyString = remainingIds.map { "nfts=\($0)" }.joined(separator: "&")
            
            var request = URLRequest(url: URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")!)
            request.httpMethod = "PUT"
            request.httpBody = bodyString.data(using: .utf8)
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")

            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw URLError(.badServerResponse)
            }

            cartItems.remove(at: index)
            cartItemsCount = cartItems.count
            total = cartItems.reduce(0) { $0 + $1.price }

        } catch {
            errorMessage = "Не удалось удалить NFT из корзины"
            print("Remove error: \(error)")
        }
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

enum SortOption: String, CaseIterable {
    case priceAscending = "По цене"
    case rating = "По рейтингу"
    case name = "По названию"
    
    var title: String { rawValue }
}

extension CartViewModel {
    var sortedCartItems: [NFTItem] {
        switch sortOption {
        case .priceAscending:
            return cartItems.sorted { $0.price < $1.price }
        case .rating:
            return cartItems.sorted { ($0.rating ?? 0) > ($1.rating ?? 0) }
        case .name:
            return cartItems.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
        case .none:
            return cartItems
        }
    }
}
