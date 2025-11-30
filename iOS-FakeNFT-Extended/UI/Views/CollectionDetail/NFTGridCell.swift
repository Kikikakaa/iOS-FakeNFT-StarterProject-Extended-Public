//
//  NFTGridCell.swift
//  iOS-FakeNFT-Extended

import SwiftUI

struct NFTGridCell: View {
    let nft: Nft
    @ObservedObject var cartViewModel: CartViewModel
    @StateObject private var favoritesService = FavoritesService()
    @State private var isProcessing = false
    @State private var cartIconName: String = "trash"
    
    init(nft: Nft, cartViewModel: CartViewModel) {
        self.nft = nft
        self._cartViewModel = ObservedObject(wrappedValue: cartViewModel)
    }
    
    private var isLiked: Bool {
        favoritesService.isFavorite(nft.id)
    }
    
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
                    handleLikeButtonTap()
                }) {
                    ZStack {
                        // Прозрачный квадрат для тапа 42x42
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: 42, height: 42)
                        
                        // Картинка лайка по центру
                        Image(isLiked ? .active : .noActiveLike)
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
                        handleCartButtonTap()
                    }) {
                        // Меняем иконку в зависимости от состояния
                        Image(cartViewModel.isInCart(nft.id) ? .trashX : .trash)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.primary)
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
        .onAppear {
            updateCartIcon()
        }
        .onChange(of: cartViewModel.cartItems) { _ in
            updateCartIcon()
        }
    }
    
    private func handleCartButtonTap() {
        guard !isProcessing else { return }
        
        isProcessing = true
        print("🎯 Кнопка нажата! NFT: \(nft.id)")
        
        Task {
            defer {
                DispatchQueue.main.async {
                    isProcessing = false
                    self.updateCartIcon()
                }
            }
            
            do {
                if cartViewModel.isInCart(nft.id) {
                    try await cartViewModel.removeFromCart(nft.id)
                    print("✅ NFT удален из корзины")
                } else {
                    try await cartViewModel.addToCart(nft.id)
                    print("✅ NFT добавлен в корзину")
                }
            } catch {
                print("❌ Ошибка при работе с корзиной: \(error)")
                
                // Более детальная обработка ошибок
                if let httpError = error as? URLError {
                    switch httpError.code {
                    case .badServerResponse:
                        if let statusCode = (httpError.userInfo["NSErrorFailingURLKey"] as? HTTPURLResponse)?.statusCode {
                            print("📊 HTTP статус: \(statusCode)")
                            if statusCode == 403 {
                                print("🚫 Ошибка доступа: проверьте токен авторизации")
                            }
                        }
                    default:
                        print("🌐 Сетевая ошибка: \(httpError.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func updateCartIcon() {
        cartIconName = cartViewModel.isInCart(nft.id) ? "trashX" : "trash"
    }
    
    private func handleLikeButtonTap() {
        print("❤️ Кнопка лайка нажата! NFT: \(nft.id)")
        favoritesService.toggleFavorite(nft.id)
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
            ), cartViewModel: CartViewModel.shared
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
