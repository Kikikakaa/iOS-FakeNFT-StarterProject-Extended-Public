//  Untitled.swift
//  iOS-FakeNFT-Extended
//
import CoreGraphics
import SwiftUI

enum AppConstants {
    
    // MARK: - Colors
    enum Colors {
        static let blueUniversal = Color(red: 0.04, green: 0.52, blue: 1.0) // #0A84FF
    }
    
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
        static let cardSize: CGSize = CGSize(width: 108, height: 192)
        static let imageSize: CGSize = CGSize(width: 108, height: 108)
        static let infoBlockSize: CGSize = CGSize(width: 108, height: 40)
        static let imageHeight: CGFloat = 140
        static let cornerRadius: CGFloat = 12
        static let padding: CGFloat = 8
        static let starSize: CGFloat = 12
        static let iconSize: CGFloat = 16
        static let likeButtonSize: CGFloat = 42
        static let likeImageSize: CGSize = CGSize(width: 21, height: 18)
        
        // Шрифты
        static let titleFontSize: CGFloat = 17
        static let priceFontSize: CGFloat = 10
        static let labelFontSize: CGFloat = 10
    }
    
    // MARK: - AuthorView
    enum AuthorView {
        static let labelFontSize: CGFloat = 13
        static let nameFontSize: CGFloat = 15
    }
    
    // MARK: - NFTGridView
    enum NFTGridView {
        static let columnsSpacing: CGFloat = 16
        static let rowSpacing: CGFloat = 16
    }
    
    // MARK: - CollectionDetailView
    enum CollectionDetail {
        static let coverHeight: CGFloat = 310
        static let coverCornerRadius: CGFloat = 12
        static let descriptionFontSize: CGFloat = 13
        
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
