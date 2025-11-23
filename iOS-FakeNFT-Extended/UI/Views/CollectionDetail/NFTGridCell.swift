//
//  NFTGridCell.swift
//  iOS-FakeNFT-Extended

import SwiftUI

struct NFTGridCell: View {
    let nft: Nft
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Изображение NFT
            AsyncImage(url: nft.images.first) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(ProgressView())
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(Image(systemName: "photo"))
                @unknown default:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
            }
            .frame(height: 140)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Название NFT
            Text(nft.name)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(1)
            
            // Рейтинг
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= nft.rating ? "star.fill" : "star")
                        .foregroundColor(star <= nft.rating ? .yellow : .gray)
                        .font(.system(size: 12))
                }
            }
            
            // Цена
            HStack {
                Text("Цена")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(nft.price, specifier: "%.2f") ETH")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.primary)
            }
        }
        .padding(8)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

struct NFTGridCell_Previews: PreviewProvider {
    static var previews: some View {
        NFTGridCell(nft: Nft(
            id: "1",
            images: [URL(string: "https://example.com/nft1.jpg")!],
            name: "Космический кот #1",
            rating: 4,
            price: 1.5,
            author: "Иван Петров"
        ))
        .frame(width: 160, height: 220)
        .padding()
    }
}
