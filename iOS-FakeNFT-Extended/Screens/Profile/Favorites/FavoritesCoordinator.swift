import Foundation

final class FavoritesCoordinator: ObservableObject {
    static let shared = FavoritesCoordinator()
    
    @Published private(set) var favoriteNFTs: [String] = []
    private let favoritesService: FavoritesServiceProtocol
    
    init() {
        self.favoritesService = FavoritesService.shared
        loadFavorites()
        
        // Подписываемся на изменения через NotificationCenter
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(favoritesUpdated),
            name: .favoritesDidChange,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func loadFavorites() {
        favoriteNFTs = favoritesService.getFavoriteNFTs()
        print("🔄 FavoritesCoordinator: Загружены избранные - \(favoriteNFTs.count) шт")
    }
    
    @objc private func favoritesUpdated() {
        print("🔄 FavoritesCoordinator: Получено уведомление об изменении избранных")
        loadFavorites()
    }
    
    var favoritesCount: String {
        let count = favoriteNFTs.count
        print("📊 FavoritesCoordinator: Текущее количество избранных - \(count)")
        return "(\(count))"
    }
    
    func isFavorite(_ nftId: String) -> Bool {
        favoritesService.isFavorite(nftId)
    }
    
    func toggleFavorite(_ nftId: String) {
        favoritesService.toggleFavorite(nftId)
    }
}
