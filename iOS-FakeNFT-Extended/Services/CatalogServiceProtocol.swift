//
//  CatalogServiceProtocol.swift
//  iOS-FakeNFT-Extended
//
import Foundation

protocol CatalogServiceProtocol {
    func fetchCollections() async throws -> [CatalogCollectionItem]
    func fetchNFTs(for collectionId: String) async throws -> [NFT]
    func fetchAuthor(for collectionId: String) async throws -> Author
}
