//
//  CollectionDetailView.swift
//  iOS-FakeNFT-Extended
//
import SwiftUI

struct CollectionDetailView: View {
    let collection: Collection

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(alignment: .leading, spacing: AppConstants.CollectionDetail.verticalSpacing) {
                    // Обложка — 1/3 высоты экрана
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
                                        .fill(Color.gray.opacity(AppConstants.Common.opacityForPlaceholder))
                                        .overlay(ProgressView())
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                case .failure:
                                    Rectangle()
                                        .fill(Color.gray.opacity(AppConstants.Common.opacityForPlaceholder))
                                        .overlay(Image(systemName: "photo"))
                                @unknown default:
                                    Rectangle()
                                        .fill(Color.gray.opacity(AppConstants.Common.opacityForPlaceholder))
                                }
                            }
                        }
                    }
                    .frame(width: geo.size.width, height: geo.size.height / AppConstants.CollectionDetail.coverHeightMultiplier)
                    .clipped()

                    // Контент под обложкой
                    VStack(alignment: .leading, spacing: AppConstants.CollectionDetail.contentSpacing) {
                        Text(collection.name)
                            .font(.system(size: AppConstants.CollectionDetail.titleFontSize, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Автор не указан")
                            .font(.system(size: AppConstants.CollectionDetail.subtitleFontSize))
                            .foregroundColor(.secondary)
                        
                        Text("Описание отсутствует")
                            .font(.system(size: AppConstants.CollectionDetail.bodyFontSize))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, AppConstants.CollectionDetail.horizontalPadding)
                    .padding(.bottom, AppConstants.CollectionDetail.bottomPadding)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } // ScrollView
        } // GeometryReader
        .navigationTitle(collection.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}


