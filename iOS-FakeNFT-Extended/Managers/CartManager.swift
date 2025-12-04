//
//  CartManager.swift
//  iOS-FakeNFT-Extended
//

import Foundation

@MainActor
final class CartManager: ObservableObject {
    @Published var cartItems: [String] = []
    static let shared = CartManager()
    
    private let cartService: CartServiceProtocol
    
    init(cartService: CartServiceProtocol = CartService()) {
        self.cartService = cartService
    }
    
    func isInCart(_ nftId: String) -> Bool {
        return cartItems.contains(nftId)
    }
    
    func addToCart(_ nftId: String) async throws {
        try await cartService.addToCart(nftId: nftId)
        if !cartItems.contains(nftId) {
            cartItems.append(nftId)
        }
    }
    
    func removeFromCart(_ nftId: String) async throws {
        try await cartService.removeFromCart(nftId: nftId)
        cartItems.removeAll { $0 == nftId }
    }
    
    func loadCart() async throws {
        let order = try await cartService.getOrder()
        cartItems = order.nfts
    }
    
    func getCartItemsCount() -> Int {
        return cartItems.count
    }
}
