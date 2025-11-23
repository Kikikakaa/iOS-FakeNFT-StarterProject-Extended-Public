//
//  CatalogViewModel.swift
//  iOS-FakeNFT-Extended
//
import Foundation

@MainActor
final class CatalogViewModel: ObservableObject {
    @Published var collections: [CatalogCollectionItem] = []
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .byName
    @Published var error: String?
    
    enum SortOption {
        case byName, byCount
        
        var displayName: String {
            switch self {
            case .byName: return "По названию"
            case .byCount: return "По количеству NFT"
            }
        }
    }
    
    private let catalogService: CatalogServiceProtocol
    
    init(catalogService: CatalogServiceProtocol = CatalogService()) {
        self.catalogService = catalogService
    }
    
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
    
    var sortedCollections: [CatalogCollectionItem] {
        switch sortOption {
        case .byName:
            return collections.sorted { $0.name < $1.name }
        case .byCount:
            return collections.sorted { $0.nftsCount > $1.nftsCount }
        }
    }
    
    func toggleSortOption() {
        sortOption = sortOption == .byName ? .byCount : .byName
    }
}
