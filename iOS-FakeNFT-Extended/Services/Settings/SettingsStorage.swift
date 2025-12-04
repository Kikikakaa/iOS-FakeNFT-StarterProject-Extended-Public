//
//  SettingsStorage.swift
//  iOS-FakeNFT-Extended
//

import Foundation

final class SettingsStorage: SettingsStorageProtocol {
    
    // MARK: - Private Properties
    
    private let userDefaults = UserDefaults.standard
    private let sortOptionKey = "sortOption"
    
    // MARK: - Public Methods
    
    func saveSortOption(_ option: CatalogViewModel.SortOption, for screen: String) {
        let key = "\(screen)_\(sortOptionKey)"
        let rawValue = rawValue(from: option)
        userDefaults.set(rawValue, forKey: key)
    }
    
    func getSortOption(for screen: String) -> CatalogViewModel.SortOption? {
        let key = "\(screen)_\(sortOptionKey)"
        guard let rawValue = userDefaults.string(forKey: key) else {
            return nil
        }
        return sortOption(from: rawValue)
    }
}

// MARK: - Private Methods

private extension SettingsStorage {
    func rawValue(from option: CatalogViewModel.SortOption) -> String {
        switch option {
        case .byName:
            return "byName"
        case .byCount:
            return "byCount"
        }
    }
    
    func sortOption(from rawValue: String) -> CatalogViewModel.SortOption? {
        switch rawValue {
        case "byName":
            return .byName
        case "byCount":
            return .byCount
        default:
            return nil
        }
    }
}
