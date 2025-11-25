//
//  MockCatalogData.swift
//  iOS-FakeNFT-Extended

import Foundation

struct MockCatalogData {
    static let catalogCollections: [CatalogCollectionItem] = [
        CatalogCollectionItem(
            id: "1",
            name: "Peach",
            cover: "mock_catalog_peach",
            nfts: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"],
            description: "Коллекция персиковых NFT",
            author: "Алексей Смирнов"
        ),
        CatalogCollectionItem(
            id: "2",
            name: "Blue",
            cover: "mock_catalog_blue",
            nfts: ["1", "2", "3", "4", "5", "6"],
            description: "Вторая коллекция NFT",
            author: "Алексей Смирнов"
        ),
        // ... остальные коллекции
    ]
    
    static let mockNFTs: [Nft] = [
        Nft(
            id: "1",
            images: [URL(string: "https://example.com/nft1.jpg")!],
            name: "Peach NFT #1",
            rating: 4,
            price: 2.5,
            author: "Алексей Смирнов"
        ),
        Nft(
            id: "2",
            images: [URL(string: "https://example.com/nft2.jpg")!],
            name: "Peach NFT #2",
            rating: 5,
            price: 3.0,
            author: "Алексей Смирнов"
        ),
    ]
    
    static let mockAuthor: Author = Author(
        name: "Алексей Смирнов",
        website: URL(string: "https://example.com/artist-portfolio")!
    )
}
