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
            nftsCount: 11
        ),
        CatalogCollectionItem(
            id: "2",
            cover: "mock_catalog_blue",
            name: "Blue",
            nftsCount: 6
        ),
        CatalogCollectionItem(
            id: "3",
            cover: "mock_catalog_brown",
            name: "Brown",
            nftsCount: 8
        ),
        CatalogCollectionItem(
            id: "4",
            cover: "mock_catalog_green",
            name: "Green",
            nftsCount: 6
        )
    ]
}
