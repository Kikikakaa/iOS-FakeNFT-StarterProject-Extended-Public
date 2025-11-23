import Foundation

struct Nft: Codable, Identifiable, Hashable {
    let id: String
    let images: [URL]
    let name: String
    let rating: Int
    let price: Double
    let author: String
    
    static func == (lhs: Nft, rhs: Nft) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

