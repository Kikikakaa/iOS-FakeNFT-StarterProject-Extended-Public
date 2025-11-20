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

    var imageUrl: String {
        images.first ?? ""
    }
    
    var priceETH: String {
        String(format: "%.2f ETH", price)
    }
    
    var ratingStars: some View {
        HStack(spacing: UIConstants.Rating.starSpacing) {
            ForEach(0..<5) { index in
                let star: ImageResource = index < rating ? .done : .noActive

                Image(star)
                    .resizable()
                    .frame(width: UIConstants.Rating.starSize, height: UIConstants.Rating.starSize)
            }
        }
    }
}
