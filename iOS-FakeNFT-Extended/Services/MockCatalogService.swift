//
//  MockCatalogService.swift
//  iOS-FakeNFT-Extended

final class MockCatalogService: CatalogServiceProtocol {
    func fetchCollections() async throws -> [Collection] {
        // Можно убрать задержку, чтобы превью загружалось мгновенно
        return MockCatalogData.catalogCollections
    }
}
