//
//  CollectionRow.swift
//  iOS-FakeNFT-Extended

import SwiftUI

struct CollectionRow: View {
    let catalogCollectionItem: CatalogCollectionItem

    var body: some View {
        VStack(alignment: .leading, spacing: AppConstants.CollectionRow.spacing) {
            
            Group {
                if catalogCollectionItem.isLocalImage {
                    Image(catalogCollectionItem.cover)
                        .resizable()
                        .scaledToFill()
                } else {
                    AsyncImage(url: URL(string: catalogCollectionItem.cover)) { phase in
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
                }
            }
            .frame(maxWidth: .infinity, minHeight: AppConstants.CollectionRow.imageSize.height,
                   maxHeight: AppConstants.CollectionRow.imageSize.height)
            .clipShape(RoundedRectangle(cornerRadius: AppConstants.CollectionRow.imageCornerRadius, style: .continuous))

            HStack(spacing: AppConstants.CollectionRow.verticalSpacing) {
                Text(catalogCollectionItem.name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text("(\(catalogCollectionItem.nftsCount))")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.primary)
            }

            Spacer()
        }
        .frame(height: AppConstants.CollectionRow.rowHeight)
        .padding(.horizontal, AppConstants.CollectionRow.horizontalPadding)
        .padding(.vertical, AppConstants.CollectionRow.verticalPadding)
        .contentShape(Rectangle())
    }
}

struct CollectionRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CollectionRow(catalogCollectionItem: CatalogCollectionItem(
                id: "1",
                cover: "mock_catalog_peach",
                name: "Космические NFT",
                nftsCount: 15,
                description: "Описание коллекции",
                author: "author_1",
                nfts: ["1", "2", "3"]
            ))
            CollectionRow(catalogCollectionItem: CatalogCollectionItem(
                id: "2",
                cover: "https://example.com/image2.jpg",
                name: "Цифровое искусство с длинным названием, чтобы проверить усечение",
                nftsCount: 8,
                description: "Еще одна коллекция",
                author: "author_2",
                nfts: ["4", "5"]
            ))
        }
        .listStyle(.plain)
    }
}

