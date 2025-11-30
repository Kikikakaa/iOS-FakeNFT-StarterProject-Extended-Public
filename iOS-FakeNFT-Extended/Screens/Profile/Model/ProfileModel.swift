import Foundation

struct ProfileModel {
    let avatarURL: URL?
    let name: String
    let description: String
    let websiteURL: URL?
    let nftsCount: String
    let likesCount: String
    let nfts: [String] // Массив ID купленных NFT
    let likes: [String] // Массив ID избранных NFT
}
