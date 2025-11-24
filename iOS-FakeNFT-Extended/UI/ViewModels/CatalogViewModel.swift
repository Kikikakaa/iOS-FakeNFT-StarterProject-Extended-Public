//
//  CatalogViewModel.swift
//  iOS-FakeNFT-Extended
//
import Foundation

@MainActor
final class CatalogViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var collections: [CatalogCollectionItem] = []
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .byCount {
        didSet {
            saveSortOption()
        }
    }
    @Published var error: String?
    
    // MARK: - Public Properties
    
    var sortedCollections: [CatalogCollectionItem] {
        switch sortOption {
        case .byName:
            return collections.sorted { $0.name < $1.name }
        case .byCount:
            return collections.sorted { $0.nftsCount > $1.nftsCount }
        }
    }
    
    // MARK: - Private Properties
    
    private let catalogService: CatalogServiceProtocol
    private let settingsStorage: SettingsStorageProtocol
    
    // MARK: - Initialization
    
    init(
        catalogService: CatalogServiceProtocol = CatalogService(),
        settingsStorage: SettingsStorageProtocol = SettingsStorage()
    ) {
        self.catalogService = catalogService
        self.settingsStorage = settingsStorage
        loadSortOption()
    }
    
    // MARK: - Public Methods
    
    func loadCollections() async {
        isLoading = true
        error = nil
        
        defer { isLoading = false }
        
        do {
            collections = try await catalogService.fetchCollections()
        } catch {
            self.error = "Не удалось загрузить коллекции: \(error.localizedDescription)"
            print("Error loading collections: \(error)")
        }
    }
    
    func toggleSortOption() {
        sortOption = sortOption == .byName ? .byCount : .byName
    }
}

// MARK: - SortOption

extension CatalogViewModel {
    enum SortOption {
        case byName
        case byCount
        
        var displayName: String {
            switch self {
            case .byName:
                return "По названию"
            case .byCount:
                return "По количеству NFT"
            }
        }
    }
}

// MARK: - Private Methods

private extension CatalogViewModel {
    func saveSortOption() {
        settingsStorage.saveSortOption(sortOption, for: "catalog")
    }
    
    func loadSortOption() {
        if let savedOption = settingsStorage.getSortOption(for: "catalog") {
            sortOption = savedOption
        }
    }
}
