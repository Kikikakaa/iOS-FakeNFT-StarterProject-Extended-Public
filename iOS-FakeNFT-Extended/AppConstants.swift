//  Untitled.swift
//  iOS-FakeNFT-Extended
//
import CoreGraphics
import SwiftUI

enum AppConstants {
    
    // MARK: - CollectionRow
    enum CollectionRow {
        static let imageSize = CGSize(width: 140, height: 140)
        static let rowHeight: CGFloat = 179
        static let imageCornerRadius: CGFloat = 12
        
        static let spacing: CGFloat = 12
        static let verticalSpacing: CGFloat = 4
        static let verticalPadding: CGFloat = 8
        static let horizontalPadding: CGFloat = 16
        static let chevronSize: CGFloat = 14
    }
    
    // MARK: - NFTGridCell
    enum NFTGridCell {
        static let imageHeight: CGFloat = 140
        static let cornerRadius: CGFloat = 12
        static let padding: CGFloat = 8
        static let starSize: CGFloat = 12
        
        // Шрифты
        static let titleFontSize: CGFloat = 14
        static let priceFontSize: CGFloat = 14
        static let labelFontSize: CGFloat = 12
    }
    
    // MARK: - NFTGridView
    enum NFTGridView {
        static let columnsSpacing: CGFloat = 16
        static let rowSpacing: CGFloat = 16
    }
    
    // MARK: - CollectionDetailView
    enum CollectionDetail {
        static let coverHeightMultiplier: CGFloat = 3.0
        static let horizontalPadding: CGFloat = 16
        static let verticalSpacing: CGFloat = 16
        static let contentSpacing: CGFloat = 8
        static let bottomPadding: CGFloat = 32
        
        // Шрифты
        static let titleFontSize: CGFloat = 22
        static let subtitleFontSize: CGFloat = 14
        static let bodyFontSize: CGFloat = 16
    }
    
    // MARK: - CatalogView
    enum Catalog {
        static let listRowInsets = EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        static let progressViewScale: CGFloat = 1.5
    }
    
    // MARK: - Common
    enum Common {
        static let defaultCornerRadius: CGFloat = 12
        static let opacityForPlaceholder: Double = 0.3
    }
}
