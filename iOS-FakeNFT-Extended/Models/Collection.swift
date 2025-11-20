//
//  Collection.swift
//  iOS-FakeNFT-Extended

import Foundation

struct Collection: Codable, Identifiable {
    let id: String
    let cover: String
    let name: String
    let nftsCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case cover
        case name
        case nftsCount = "nfts_count"
    }
}
