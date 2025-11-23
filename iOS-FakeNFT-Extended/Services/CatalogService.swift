//
//  CatalogService.swift
//  iOS-FakeNFT-Extended
import Foundation

final class CatalogService: CatalogServiceProtocol {
    func fetchCollections() async throws -> [CatalogCollectionItem] {
        // Имитация сетевого запроса с задержкой
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 секунды
        
        // Mock данные
        return [
            CatalogCollectionItem(
                id: "1",
                cover: "https://example.com/collection1.jpg",
                name: "Космические коты",
                nftsCount: 15,
                description: "Уникальная коллекция космических котов",
                author: "author_1",
                nfts: ["1", "2", "3"]
            ),

            CatalogCollectionItem(
                id: "2",
                cover: "https://example.com/collection2.jpg",
                name: "Цифровое искусство",
                nftsCount: 8,
                description: "Уникальная коллекция цифрового искусства",
                author: "author_1",
                nfts: ["1", "2", "3"]
                ),
            CatalogCollectionItem(
                id: "3",
                cover: "https://example.com/collection3.jpg",
                name: "Абстракции",
                nftsCount: 12,
                description: "Уникальная коллекция абстракций",
                author: "author_1",
                nfts: ["1", "2", "3"]
                
            ),
            CatalogCollectionItem(
                id: "4",
                cover: "https://example.com/collection4.jpg",
                name: "Винтаж",
                nftsCount: 6,
                description: "Коллекция винтаж",
                author: "author_1",
                nfts: ["1", "2", "3"]
            ),
            CatalogCollectionItem(
                id: "5",
                cover: "https://example.com/collection5.jpg",
                name: "Футуризм",
                nftsCount: 9,
                description: "Уникальная коллекция футуризм",
                author: "author_1",
                nfts: ["1", "2", "3"]
            )
        ]
    }
    
    func fetchNFTs(for collectionId: String) async throws -> [NFT] {
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        return [
            NFT(
                id: "1",
                images: [URL(string: "https://example.com/nft1.jpg")!],
                name: "Космический кот #1",
                rating: 5,
                price: 1.5
            )
        ]
    }
    
    func fetchAuthor(for collectionId: String) async throws -> Author {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        return Author(
            name: "Иван Петров",
            website: URL(string: "https://example.com/artist")!
        )
    }
}

