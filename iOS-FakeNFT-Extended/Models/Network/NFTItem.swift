import Foundation
import SwiftUI

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
    
    var ratingStars: some View {
        HStack(spacing: 3) {
            ForEach(0..<5) { index in
                Image(index < rating ? "done" : "noActive")
                    .resizable()
                    .frame(width: 12, height: 12)
            }
        }
    }
}
