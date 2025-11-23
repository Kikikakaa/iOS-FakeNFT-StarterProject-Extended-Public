//
//  CatalogServiceProtocol.swift
//  iOS-FakeNFT-Extended
//
import Foundation

protocol CatalogServiceProtocol {
    func fetchCollections() async throws -> [CatalogCollectionItem]
}
