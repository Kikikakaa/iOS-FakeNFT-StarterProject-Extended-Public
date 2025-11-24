//
//  NFTGridView.swift
//  iOS-FakeNFT-Extended

import SwiftUI

struct NFTGridView: View {
    let nfts: [Nft]
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(nfts, id: \.uniqueId) { nft in  // ← используем uniqueId
                NFTGridCell(nft: nft)
            }
        }
    }
}

struct NFTGridView_Previews: PreviewProvider {
    static var previews: some View {
        NFTGridView(nfts: [
            Nft(
                id: "1",
                images: [URL(string: "https://example.com/nft1.jpg")!],
                name: "NFT #1",
                rating: 4,
                price: 1.5,
                author: "Иван Петров"
            ),
            Nft(
                id: "2",
                images: [URL(string: "https://example.com/nft2.jpg")!],
                name: "NFT #2",
                rating: 5,
                price: 2.0,
                author: "Иван Петров"
            ),
            Nft(
                id: "3",
                images: [URL(string: "https://example.com/nft2.jpg")!],
                name: "NFT #3",
                rating: 3,
                price: 4.0,
                author: "Иван Петров"
            )
        ])
        .padding()
    }
}
