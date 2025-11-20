//
//  CollectionRow.swift
//  iOS-FakeNFT-Extended

import SwiftUI

struct CollectionRow: View {
    let collection: Collection

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Group {
                if collection.isLocalImage {
                    Image(collection.cover)
                        .resizable()
                        .scaledToFill()
                } else {
                    AsyncImage(url: URL(string: collection.cover)) { phase in
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
            .frame(maxWidth: .infinity, minHeight: 140, maxHeight: 140)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            HStack(spacing: 4) {
                Text(collection.name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text("(\(collection.nftsCount))")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.primary)
            }

            Spacer()
        }
        .frame(height: 179)
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

struct CollectionRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CollectionRow(collection: Collection(
                id: "1",
                cover: "mock_catalog_peach",
                name: "Космические NFT",
                nftsCount: 15
            ))
            CollectionRow(collection: Collection(
                id: "2",
                cover: "https://example.com/image2.jpg",
                name: "Цифровое искусство с длинным названием, чтобы проверить усечение",
                nftsCount: 8
            ))
        }
        .listStyle(.plain)
    }
}

