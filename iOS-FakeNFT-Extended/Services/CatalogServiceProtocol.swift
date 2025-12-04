//
//  CatalogServiceProtocol.swift
//  iOS-FakeNFT-Extended
//
import Foundation

protocol CatalogServiceProtocol {
    func fetchCollections() async throws -> [CatalogCollectionItem]
    func fetchNFTs(for collectionId: String) async throws -> [Nft]
    func fetchAuthor(for collectionId: String) async throws -> Author
    
    func addToCart(nftId: String) async throws
    func removeFromCart(nftId: String) async throws
}
