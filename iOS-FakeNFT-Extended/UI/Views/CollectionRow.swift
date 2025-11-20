//
//  CollectionRow.swift
//  iOS-FakeNFT-Extended

import SwiftUI

struct CollectionRow: View {
    let collection: Collection
    
    var body: some View {
        HStack(spacing: 12) {
            // Обложка коллекции
            AsyncImage(url: URL(string: collection.cover)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        ProgressView()
                    )
            }
            .frame(width: 60, height: 60)
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(collection.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("\(collection.nftsCount) NFT")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.system(size: 14, weight: .medium))
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}

