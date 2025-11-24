//
//  CollectionDetailView.swift
//  iOS-FakeNFT-Extended
//
import SwiftUI

struct CollectionDetailView: View {
    let catalogCollectionItem: CatalogCollectionItem
    @StateObject private var viewModel: CollectionDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(catalogCollectionItem: CatalogCollectionItem) {
        self.catalogCollectionItem = catalogCollectionItem
        _viewModel = StateObject(wrappedValue: CollectionDetailViewModel(collectionId: catalogCollectionItem.id))
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    // Обложка
                    ZStack(alignment: .topLeading) {
                        coverImage
                            .frame(width: geo.size.width, height: geo.size.height * 0.4)
                            .clipped()
                        
                        // Кнопка назад с прозрачным фоном
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.black.opacity(0.3))
                                .clipShape(Circle())
                        }
                        .padding(.top, 60) // Отступ от верха безопасной зоны
                        .padding(.leading, 16)
                    }
                    
                    // Контент под обложкой
                    VStack(alignment: .leading, spacing: 16) {
                        Text(catalogCollectionItem.name)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.primary)
                        
                        if let author = viewModel.author {
                            AuthorView(author: author)
                        } else {
                            Text("Автор не указан")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(catalogCollectionItem.description)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20) // Отступ от обложки
                    
                    // Сетка NFT
                    if !viewModel.nfts.isEmpty {
                        Text("NFT коллекции")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.horizontal, 16)
                            .padding(.top, 24)
                        
                        NFTGridView(nfts: viewModel.nfts)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 20)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } // ScrollView
            .edgesIgnoringSafeArea(.top) // Обложка игнорирует safe area
        } // GeometryReader
        .navigationBarHidden(true) // Скрываем навигационную панель полностью
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
        .task {
            await viewModel.fetchData()
        }
    }
    
    private var coverImage: some View {
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
    }
}
