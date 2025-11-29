//
//  FavoritesServiceProtocol.swift
//  iOS-FakeNFT-Extended
//
import Foundation

protocol FavoritesServiceProtocol {
    func getFavoriteNFTs() -> [String]
    func addToFavorites(_ nftId: String)
    func removeFromFavorites(_ nftId: String)
    func isFavorite(_ nftId: String) -> Bool
    func toggleFavorite(_ nftId: String)
}
