//
//  CatalogService.swift
//  iOS-FakeNFT-Extended
//
import Foundation

final class CatalogService: CatalogServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchCollections() async throws -> [CatalogCollectionItem] {
        let request = CollectionsRequest()
        let collections: [CatalogCollectionItem] = try await networkClient.send(request: request)
        return collections
    }
    
    func fetchNFTs(for collectionId: String) async throws -> [Nft] {
        let request = NFTsByCollectionRequest(collectionId: collectionId)
        
        // Получаем детальную информацию о коллекции, которая содержит NFT
        let collectionDetail: CatalogCollectionItem = try await networkClient.send(request: request)
        
        // Загружаем информацию о каждом NFT
        var nfts: [Nft] = []
        for nftId in collectionDetail.nfts {
            let nftRequest = NFTRequest(id: nftId)
            let nft: Nft = try await networkClient.send(request: nftRequest)
            nfts.append(nft)
        }
        
        return nfts
    }
    
    func fetchAuthor(for collectionId: String) async throws -> Author {
        let request = NFTsByCollectionRequest(collectionId: collectionId)
        let collectionDetail: CatalogCollectionItem = try await networkClient.send(request: request)
        
        return Author(
            name: collectionDetail.author,
            website: URL(string: "https://example.com/artist")! // Заглушка, нужно уточнить API
        )
    }
}
