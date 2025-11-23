//
//  NFTsByCollectionRequest.swift
//  iOS-FakeNFT-Extended
//

import Foundation

struct NFTsByCollectionRequest: NetworkRequest {
    let collectionId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections/\(collectionId)")
    }
    
    var httpMethod: HttpMethod { .get }
}
