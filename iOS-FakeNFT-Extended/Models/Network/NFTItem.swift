import Foundation

struct NFTItem: Codable, Identifiable {
    let createdAt: String?
    let name: String
    let images: [String]
    let rating: Int
    let description: String?
    let price: Double
    let author: String
    let id: String

    // Для SwiftUI
    var imageUrl: String {
        images.first ?? ""
    }

    var priceETH: String {
        String(format: "%.2f ETH", price)
    }

    var ratingStars: String {
        String(repeating: "★", count: rating) + String(repeating: "☆", count: 5 - rating)
    }
}
