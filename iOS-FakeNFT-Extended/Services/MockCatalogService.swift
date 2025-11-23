//
//  MockCatalogService.swift
//  iOS-FakeNFT-Extended

final class MockCatalogService: CatalogServiceProtocol {
    func fetchCollections() async throws -> [CatalogCollectionItem] {
        // Можно добавить небольшую задержку для реалистичности
        try await Task.sleep(nanoseconds: 500_000_000)
        return MockCatalogData.catalogCollections
    }
    
    func fetchNFTs(for collectionId: String) async throws -> [Nft] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return MockCatalogData.mockNFTs
    }
    
    func fetchAuthor(for collectionId: String) async throws -> Author {
        try await Task.sleep(nanoseconds: 500_000_000)
        return MockCatalogData.mockAuthor
    }
}
