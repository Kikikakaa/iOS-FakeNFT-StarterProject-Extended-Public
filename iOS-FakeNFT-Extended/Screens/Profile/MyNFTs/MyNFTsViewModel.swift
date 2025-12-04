import Foundation

@MainActor
final class MyNFTsViewModel: ObservableObject {
    
    @Published var nfts: [Nft] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private let nftService: NftService
    private let profile: ProfileModel
    private let profileService: ProfileService
    private let onProfileUpdate: (ProfileModel) -> Void
    private let favoritesService: FavoritesServiceProtocol
    
    init(
        profile: ProfileModel,
        nftService: NftService,
        profileService: ProfileService,
        onProfileUpdate: @escaping (ProfileModel) -> Void,
        favoritesService: FavoritesServiceProtocol = FavoritesService.shared
    ) {
        self.profile = profile
        self.nftService = nftService
        self.profileService = profileService
        self.onProfileUpdate = onProfileUpdate
        self.favoritesService = favoritesService
        
        print("🎯 MyNFTsViewModel инициализирован")
        print("📊 NFT в профиле: \(profile.nfts.count) шт.")
        print("❤️ Избранных в профиле: \(profile.likes.count) шт.")
    }
    
    func loadData() {
        guard nfts.isEmpty else { return }
        isLoading = true
        
        Task {
            do {
                var loadedNfts: [Nft] = []
                // Берем ID из профиля
                for id in profile.nfts {
                    print("⬇️ Загружаю NFT с id: \(id)")
                    let nft = try await nftService.loadNft(id: id)
                    loadedNfts.append(nft)
                }
                // Сортировка по умолчанию (рейтинг)
                self.nfts = loadedNfts.sorted { $0.rating > $1.rating }
                self.isLoading = false
                print("✅ Загружено \(self.nfts.count) NFT")
            } catch {
                print("❌ Ошибка: \(error)")
                self.error = error
                self.isLoading = false
            }
        }
    }
    
    func toggleLike(for nft: Nft) {
        print("🔄 Переключаю лайк для NFT: \(nft.id), текущий статус: \(isLiked(nft: nft))")
        
        // Используем FavoritesService вместо обновления профиля
        if favoritesService.isFavorite(nft.id) {
            favoritesService.removeFromFavorites(nft.id)
            print("➖ Удален из избранных: \(nft.id)")
        } else {
            favoritesService.addToFavorites(nft.id)
            print("➕ Добавлен в избранные: \(nft.id)")
        }
        
        // Обновляем UI через Published свойство
        objectWillChange.send()
        
        let updatedProfile = ProfileModel(
            avatarURL: profile.avatarURL,
            name: profile.name,
            description: profile.description,
            websiteURL: profile.websiteURL,
            nftsCount: profile.nftsCount,
            likesCount: "(\(favoritesService.getFavoriteNFTs().count))", // Берем из сервиса
            nfts: profile.nfts,
            likes: favoritesService.getFavoriteNFTs() // Берем из сервиса
        )
        
        onProfileUpdate(updatedProfile)
    }
    
    // Проверка, лайкнут ли NFT
    func isLiked(nft: Nft) -> Bool {
        return favoritesService.isFavorite(nft.id)
    }
    
    enum SortOption {
        case price, rating, name
    }
    
    func sort(by option: SortOption) {
        switch option {
        case .price: nfts.sort { $0.price < $1.price }
        case .rating: nfts.sort { $0.rating > $1.rating }
        case .name: nfts.sort { $0.name < $1.name }
        }
        print("🔀 Отсортировано по: \(option)")
    }
}
