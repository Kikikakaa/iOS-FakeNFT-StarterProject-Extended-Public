import Foundation

struct OrderResponse: Codable {
    let nfts: [String]  // ID NFT в корзине
    let id: String      // ID заказа
}
