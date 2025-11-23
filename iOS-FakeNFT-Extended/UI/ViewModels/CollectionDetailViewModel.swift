//
//  CollectionDetailViewModel.swift
//  iOS-FakeNFT-Extended

import Foundation

@MainActor
final class CollectionDetailViewModel: ObservableObject {
    @Published var nfts: [Nft] = []
    @Published var author: Author?
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    private let collectionId: String
    private let catalogService: CatalogServiceProtocol
    
    init(collectionId: String, catalogService: CatalogServiceProtocol = CatalogService()) {
        self.collectionId = collectionId
        self.catalogService = catalogService
    }
    
    func fetchData() async {
        isLoading = true
        error = nil
        
        defer { isLoading = false }
        
        do {
            async let nftsTask = catalogService.fetchNFTs(for: collectionId)
            async let authorTask = catalogService.fetchAuthor(for: collectionId)
            
            let (fetchedNFTs, fetchedAuthor) = try await (nftsTask, authorTask)
            
            print("Загружено NFT: \(fetchedNFTs.count)")
            fetchedNFTs.forEach { nft in
                print("NFT: \(nft.name), images: \(nft.images.count)")
            }
            
            self.nfts = fetchedNFTs
            self.author = fetchedAuthor
        } catch {
            self.error = "Не удалось загрузить данные: \(error.localizedDescription)"
            print("Error loading collection details: \(error)")
        }
    }
}
