//
//  NFT.swift
//  iOS-FakeNFT-Extended
//
import Foundation

struct NFT: Codable, Identifiable, Hashable {
    let id: String
    let images: [URL]
    let name: String
    let rating: Int
    let price: Double
    
    static func == (lhs: NFT, rhs: NFT) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
