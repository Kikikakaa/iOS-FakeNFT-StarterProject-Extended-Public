//
//  MockCatalogData.swift
//  iOS-FakeNFT-Extended

import Foundation

struct MockCatalogData {
    static let catalogCollections: [Collection] = [
        Collection(
            id: "1",
            cover: "mock_catalog_peach",
            name: "Peach",
            nftsCount: 11
        ),
        Collection(
            id: "2",
            cover: "mock_catalog_blue",
            name: "Blue",
            nftsCount: 6
        ),
        Collection(
            id: "3",
            cover: "mock_catalog_brown",
            name: "Brown",
            nftsCount: 8
        ),
        Collection(
            id: "4",
            cover: "mock_catalog_green",
            name: "Green",
            nftsCount: 6
        )
    ]
}
