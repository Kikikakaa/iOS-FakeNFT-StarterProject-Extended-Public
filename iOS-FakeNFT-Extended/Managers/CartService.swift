//
//  CartService.swift
//  iOS-FakeNFT-Extended
//

final class CartService: CartServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func getOrder() async throws -> OrderResponse {
        let request = GetOrderRequest()
        return try await networkClient.send(request: request)
    }
    
    func addToCart(nftId: String) async throws {
        let currentOrder = try await getOrder()
        var updatedNFTs = currentOrder.nfts
        updatedNFTs.append(nftId)
        _ = try await updateOrder(nfts: updatedNFTs)
    }
    
    func removeFromCart(nftId: String) async throws {
        let currentOrder = try await getOrder()
        let updatedNFTs = currentOrder.nfts.filter { $0 != nftId }
        _ = try await updateOrder(nfts: updatedNFTs)
    }
    
    func updateOrder(nfts: [String]) async throws -> OrderResponse {
        let request = UpdateOrderRequest(nfts: nfts)
        return try await networkClient.send(request: request)
    }
    
    func clearCart() async throws {
        _ = try await updateOrder(nfts: [])
    }
}
