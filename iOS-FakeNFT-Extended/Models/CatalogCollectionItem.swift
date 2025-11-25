//
//  Collection.swift
//  iOS-FakeNFT-Extended

import Foundation

struct CatalogCollectionItem: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    
    var nftsCount: Int {
        return nfts.count
    }

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
