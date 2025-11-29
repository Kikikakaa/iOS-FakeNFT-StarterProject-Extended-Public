import Foundation

struct Currency: Codable, Identifiable {
    let id: String
    let title: String
    let name: String
    let image: String

    var imageUrl: String { image }
    var displayName: String { name }
}
