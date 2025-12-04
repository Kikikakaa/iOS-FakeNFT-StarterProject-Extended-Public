import Foundation

@MainActor
final class FavoriteNFTsViewModel: ObservableObject {
    
    @Published var nfts: [Nft] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let nftService: NftService
    private let favoritesService: FavoritesServiceProtocol
    
    init(nftService: NftService, favoritesService: FavoritesServiceProtocol = FavoritesService.shared) { // Используем shared
        self.nftService = nftService
        self.favoritesService = favoritesService
        
        print("🎯 FavoriteNFTsViewModel инициализирован")
        print("📊 Имеется \(favoritesService.getFavoriteNFTs().count) избранных")
        
        // Подписываемся на изменения
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(favoritesDidChange),
            name: .favoritesDidChange,
            object: nil
        )
        
        loadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadData() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let favoriteIds = favoritesService.getFavoriteNFTs()
                var loadedNfts: [Nft] = []
                
                for id in favoriteIds {
                    let nft = try await nftService.loadNft(id: id)
                    loadedNfts.append(nft)
                }
                
                self.nfts = loadedNfts.sorted { $0.name < $1.name }
                self.isLoading = false
            } catch {
                self.errorMessage = "Не удалось загрузить NFT"
                self.isLoading = false
                print("Ошибка загрузки избранных NFT: \(error)")
            }
        }
    }
    
    // Удаление из избранного
    func unlikeNft(nft: Nft) {
        favoritesService.removeFromFavorites(nft.id)
        nfts.removeAll { $0.id == nft.id }
    }
    
    @objc private func favoritesDidChange() {
        // Перезагружаем данные при изменении избранного
        loadData()
    }
}
