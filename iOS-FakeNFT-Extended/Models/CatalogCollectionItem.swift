//
//  Collection.swift
//  iOS-FakeNFT-Extended

import Foundation

struct CatalogCollectionItem: Codable, Identifiable, Hashable {
    let id: String
    let cover: String
    let name: String
    let nftsCount: Int
    let description: String?
    let author: String?
    let nfts: [String]?

    static func == (lhs: CatalogCollectionItem, rhs: CatalogCollectionItem) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var isLocalImage: Bool {
        // Если cover не начинается с http, считаем что это локальный ассет
        return !cover.hasPrefix("http")
    }
}
