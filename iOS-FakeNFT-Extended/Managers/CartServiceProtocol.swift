//
//  CartServiceProtocol.swift
//  iOS-FakeNFT-Extended
//
protocol CartServiceProtocol {
    func getOrder() async throws -> OrderResponse
    func addToCart(nftId: String) async throws
    func removeFromCart(nftId: String) async throws
    func clearCart() async throws
}
