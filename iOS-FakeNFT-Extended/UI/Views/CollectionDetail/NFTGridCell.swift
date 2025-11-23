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

                // Кнопка лайка
                Button(action: {
                    isLiked.toggle()
                }) {
                    (Image(isLiked ? .active : .noActive))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: AppConstants.NFTGridCell.likeButtonSize,
                            height: AppConstants.NFTGridCell.likeButtonSize
                        )
                }
                .padding(4)
            }

            // Рейтинг (звездочки)
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= nft.rating ? "star.fill" : "star")
                        .foregroundColor(star <= nft.rating ? .yellow : .gray)
                        .font(.system(size: AppConstants.NFTGridCell.starSize))
                }
            }

            // Информационный блок (108x40)
            ZStack {
                // Фон блока
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
                            )  // ← Medium 500
                            .foregroundColor(.primary)
                    }

                    Spacer()

                    // Правая часть - кнопка корзины
                    Button(action: {
                        // Действие добавления в корзину
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
