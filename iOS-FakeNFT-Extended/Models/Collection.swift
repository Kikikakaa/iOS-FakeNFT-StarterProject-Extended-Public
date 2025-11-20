//
//  Collection.swift
//  iOS-FakeNFT-Extended

import Foundation

struct Collection: Codable, Identifiable, Hashable {
    let id: String
    let cover: String
    let name: String
    let nftsCount: Int

    static func == (lhs: Collection, rhs: Collection) -> Bool {
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
