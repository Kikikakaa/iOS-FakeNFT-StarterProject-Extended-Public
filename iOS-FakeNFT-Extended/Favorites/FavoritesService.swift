//
//  FavoritesService.swift
//  iOS-FakeNFT-Extended
//
import Foundation

final class FavoritesService: ObservableObject, FavoritesServiceProtocol {
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "favoriteNFTs"
    
    @Published private var favorites: [String] = []
    
    init() {
        favorites = userDefaults.stringArray(forKey: favoritesKey) ?? []
    }
    
    func getFavoriteNFTs() -> [String] {
        return userDefaults.stringArray(forKey: favoritesKey) ?? []
    }
    
    func addToFavorites(_ nftId: String) {
        var favorites = getFavoriteNFTs()
        if !favorites.contains(nftId) {
            favorites.append(nftId)
            userDefaults.set(favorites, forKey: favoritesKey)
            objectWillChange.send()
            print("⭐ Добавлено в избранное: \(nftId)")
        }
    }
    
    func removeFromFavorites(_ nftId: String) {
        var favorites = getFavoriteNFTs()
        favorites.removeAll { $0 == nftId }
        userDefaults.set(favorites, forKey: favoritesKey)
        objectWillChange.send() 
        print("⭐ Удалено из избранного: \(nftId)")
    }
    
    func isFavorite(_ nftId: String) -> Bool {
        return getFavoriteNFTs().contains(nftId)
    }
    
    func toggleFavorite(_ nftId: String) {
        if isFavorite(nftId) {
            removeFromFavorites(nftId)
        } else {
            addToFavorites(nftId)
        }
    }
}
