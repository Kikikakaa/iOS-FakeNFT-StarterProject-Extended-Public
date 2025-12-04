//
//  Untitled.swift
//  iOS-FakeNFT-Extended
//
import Foundation

protocol SettingsStorageProtocol {
    func saveSortOption(_ option: CatalogViewModel.SortOption, for screen: String)
    func getSortOption(for screen: String) -> CatalogViewModel.SortOption?
}
