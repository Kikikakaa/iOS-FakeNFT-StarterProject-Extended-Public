// FavoritesService.swift
import Foundation

final class FavoritesService: ObservableObject, FavoritesServiceProtocol {
    static let shared = FavoritesService()
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "favoriteNFTs"
    
    @Published private(set) var favorites: [String] = []
    
    private init() {
        loadFavorites()
    }
    
    private func loadFavorites() {
        favorites = userDefaults.stringArray(forKey: favoritesKey) ?? []
    }
    
    private func saveFavorites() {
        userDefaults.set(favorites, forKey: favoritesKey)
        // Обновляем Published свойство
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
    }
    
    func getFavoriteNFTs() -> [String] {
        return favorites
    }
    
    func addToFavorites(_ nftId: String) {
        if !favorites.contains(nftId) {
            favorites.append(nftId)
            saveFavorites()
        }
    }
    
    func removeFromFavorites(_ nftId: String) {
        favorites.removeAll { $0 == nftId }
        saveFavorites()
    }
    
    func isFavorite(_ nftId: String) -> Bool {
        return favorites.contains(nftId)
    }
    
    func toggleFavorite(_ nftId: String) {
        if isFavorite(nftId) {
            removeFromFavorites(nftId)
        } else {
            addToFavorites(nftId)
        }
    }
}
