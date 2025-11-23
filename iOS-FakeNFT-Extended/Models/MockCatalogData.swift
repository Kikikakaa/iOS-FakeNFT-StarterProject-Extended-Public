//
//  MockCatalogData.swift
//  iOS-FakeNFT-Extended

import Foundation

struct MockCatalogData {
    static let catalogCollections: [CatalogCollectionItem] = [
        CatalogCollectionItem(
            id: "1",
            cover: "mock_catalog_peach",
            name: "Peach",
            nftsCount: 11,
            description: "Коллекция персиковых NFT",
            author: "author_1",
            nfts: ["1", "2", "3"]
        ),
        CatalogCollectionItem(
            id: "2",
            cover: "mock_catalog_blue",
            name: "Blue",
            nftsCount: 6,
            description: "Вторая коллекция NFT",
            author: "author_1",
            nfts: ["1", "2", "3"]
        ),
        CatalogCollectionItem(
            id: "3",
            cover: "mock_catalog_brown",
            name: "Brown",
            nftsCount: 8,
            description: "Третья коллекция NFT",
            author: "author_1",
            nfts: ["1", "2", "3"]
        ),
        CatalogCollectionItem(
            id: "4",
            cover: "mock_catalog_green",
            name: "Green",
            nftsCount: 6,
            description: "Четвертая коллекция NFT",
            author: "author_1",
            nfts: ["1", "2", "3"]
        ),
    ]

    static let mockNFTs: [NFT] = [
        NFT(
            id: "1",
            images: [URL(string: "https://example.com/nft1.jpg")!],
            name: "Peach NFT #1",
            rating: 4,
            price: 2.5
        ),
        NFT(
            id: "2",
            images: [URL(string: "https://example.com/nft2.jpg")!],
            name: "Peach NFT #2",
            rating: 5,
            price: 3.0
        ),
    ]

    static let mockAuthor: Author = Author(
        name: "Алексей Смирнов",
        website: URL(string: "https://example.com/artist-portfolio")!
    )
}
