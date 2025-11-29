//
//  NFTItem+Ext.swift
//  iOS-FakeNFT-Extended
//
import Foundation

extension NFTItem: Equatable {
    static func == (lhs: NFTItem, rhs: NFTItem) -> Bool {
        return lhs.id == rhs.id
    }
}
