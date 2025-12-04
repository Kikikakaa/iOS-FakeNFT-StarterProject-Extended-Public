//
//  AddToCartRequest.swift
//  iOS-FakeNFT-Extended
//
import Foundation

struct AddToCartRequest: NetworkRequest {
    let nftId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/nfts/\(nftId)")
    }
    var httpMethod: HttpMethod { .post }
}

struct RemoveFromCartRequest: NetworkRequest {
    let nftId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/nfts/\(nftId)")
    }
    var httpMethod: HttpMethod { .delete }
}
