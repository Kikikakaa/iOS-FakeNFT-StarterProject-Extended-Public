//
//  CollectionDetailView.swift
//  iOS-FakeNFT-Extended
//
import SwiftUI

struct CollectionDetailView: View {
    let catalogCollectionItem: CatalogCollectionItem

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Обложка — 1/3 высоты экрана
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
                    .frame(width: geo.size.width, height: geo.size.height / 3)
                    .clipped()

                    // Контент под обложкой
                    VStack(alignment: .leading, spacing: 8) {
                        Text(catalogCollectionItem.name)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Автор не указан")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("Описание отсутствует")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } // ScrollView
        } // GeometryReader
        .navigationTitle(catalogCollectionItem.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
