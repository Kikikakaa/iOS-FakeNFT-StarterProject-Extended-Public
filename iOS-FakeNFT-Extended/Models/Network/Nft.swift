import Foundation

struct Nft: Codable, Identifiable, Hashable {
    let id: String
    let images: [URL]
    let name: String
    let rating: Int
    let price: Double
    let author: String
    
    var guaranteedUniqueId: String {
        return "\(id)-\(name)-\(images.count)-\(rating)-\(price)"
    }
    
    static func == (lhs: Nft, rhs: Nft) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

