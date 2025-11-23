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
            CatalogCollectionItem(id: "1", cover: "https://example.com/collection1.jpg", name: "Космические коты", nftsCount: 15),
            CatalogCollectionItem(id: "2", cover: "https://example.com/collection2.jpg", name: "Цифровое искусство", nftsCount: 8),
            CatalogCollectionItem(id: "3", cover: "https://example.com/collection3.jpg", name: "Абстракции", nftsCount: 12),
            CatalogCollectionItem(id: "4", cover: "https://example.com/collection4.jpg", name: "Винтаж", nftsCount: 6),
            CatalogCollectionItem(id: "5", cover: "https://example.com/collection5.jpg", name: "Футуризм", nftsCount: 9)
        ]
    }
}

