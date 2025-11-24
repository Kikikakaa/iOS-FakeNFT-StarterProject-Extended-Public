//
//  NFTGridCell.swift
//  iOS-FakeNFT-Extended

import SwiftUI

struct NFTGridCell: View {
    let nft: Nft
    @State private var isLiked = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Блок с изображением и лайком
            ZStack(alignment: .topTrailing) {
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
                .frame(
                    width: AppConstants.NFTGridCell.imageSize.width,
                    height: AppConstants.NFTGridCell.imageSize.height
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: AppConstants.NFTGridCell.cornerRadius
                    )
                )

                Button(action: {
                    isLiked.toggle()
                }) {
                    ZStack {
                        // Прозрачный квадрат для тапа 42x42
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: 42, height: 42)
                        
                        // Картинка лайка по центру
                        Image(isLiked ? .active : .noActive)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 42, height: 42)
                    }
                }
            }

            // Рейтинг (звездочки из ассетов)
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { star in
                    Image(star <= nft.rating ? .activeStars : .noActiveStars)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: AppConstants.NFTGridCell.starSize,
                            height: AppConstants.NFTGridCell.starSize
                        )
                }
            }

            ZStack {
                Rectangle()
                    .fill(Color.clear)
                    .frame(
                        width: AppConstants.NFTGridCell.infoBlockSize.width,
                        height: AppConstants.NFTGridCell.infoBlockSize.height
                    )

                HStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(nft.name)
                            .font(
                                .system(
                                    size: AppConstants.NFTGridCell
                                        .titleFontSize,
                                    weight: .bold
                                )
                            )
                            .foregroundColor(.primary)
                            .lineLimit(1)

                        Text("\(nft.price, specifier: "%.2f") ETH")
                            .font(
                                .system(
                                    size: AppConstants.NFTGridCell
                                        .priceFontSize,
                                    weight: .medium
                                )
                            )
                            .foregroundColor(.primary)
                    }

                    Spacer()

                    Button(action: {
                        print("Добавить в корзину: \(nft.name)")
                    }) {
                        Image(.trash)
                            .font(
                                .system(size: AppConstants.NFTGridCell.iconSize)
                            )
                            .foregroundColor(.primary)
                            .frame(width: 24, height: 24)
                    }
                }
                .padding(.horizontal, 4)
            }
            .frame(
                width: AppConstants.NFTGridCell.infoBlockSize.width,
                height: AppConstants.NFTGridCell.infoBlockSize.height
            )
        }
        .padding(AppConstants.NFTGridCell.padding)
        .frame(
            width: AppConstants.NFTGridCell.cardSize.width,
            height: AppConstants.NFTGridCell.cardSize.height
        )
        .background(Color(.systemBackground))
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppConstants.NFTGridCell.cornerRadius
            )
        )
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

struct NFTGridCell_Previews: PreviewProvider {
    static var previews: some View {
        NFTGridCell(
            nft: Nft(
                id: "1",
                images: [URL(string: "https://example.com/nft1.jpg")!],
                name: "Космический кот",
                rating: 4,
                price: 1.5,
                author: "Иван Петров"
            )
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
