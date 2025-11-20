//
//  CatalogService.swift
//  iOS-FakeNFT-Extended
import Foundation

final class CatalogService: CatalogServiceProtocol {
    func fetchCollections() async throws -> [Collection] {
        // Имитация сетевого запроса с задержкой
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 секунды
        
        // Mock данные
        return [
            Collection(id: "1", cover: "https://example.com/collection1.jpg", name: "Космические коты", nftsCount: 15),
            Collection(id: "2", cover: "https://example.com/collection2.jpg", name: "Цифровое искусство", nftsCount: 8),
            Collection(id: "3", cover: "https://example.com/collection3.jpg", name: "Абстракции", nftsCount: 12),
            Collection(id: "4", cover: "https://example.com/collection4.jpg", name: "Винтаж", nftsCount: 6),
            Collection(id: "5", cover: "https://example.com/collection5.jpg", name: "Футуризм", nftsCount: 9)
        ]
    }
}

