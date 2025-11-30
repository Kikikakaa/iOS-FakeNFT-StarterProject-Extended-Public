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
        
        print("=== Collection Detail ===")
        print("Collection ID: \(collectionDetail.id)")
        print("Collection Name: \(collectionDetail.name)")
        print("Author: \(collectionDetail.author)")
        print("Cover: \(collectionDetail.cover)")
        print("Description: \(collectionDetail.description)")
        print("NFTs count: \(collectionDetail.nfts.count)")
        print("=========================")
        
        let authorName = collectionDetail.author
        
        // Создаем базовый URL на основе имени автора // Не нашел ссылку на автора в апи, в Фигме указана страница курса
        let websiteURL = URL(string: "https://practicum.yandex.ru/ios-developer/?ysclid=miemx8dhnq911229428")!
        
        return Author(
            name: authorName,
            website: websiteURL
        )
    }
    
    func addToCart(nftId: String) async throws {
        try await CartViewModel.shared.addToCart(nftId)
    }
    
    func removeFromCart(nftId: String) async throws {
        try await CartViewModel.shared.removeFromCart(nftId)
    }
}
