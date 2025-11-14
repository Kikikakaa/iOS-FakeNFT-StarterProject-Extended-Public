// CartItemRow.swift
import SwiftUI
import Kingfisher

struct CartItemRow: View {
    let item: NFTItem
    let onDelete: () -> Void

    var body: some View {
        HStack {
            KFImage(URL(string: item.imageUrl))
                .placeholder { Color.gray.frame(width: 108, height: 108) }
                .resizable()
                .scaledToFill()
                .frame(width: 108, height: 108)
                .clipped()
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 5) {
                Text(item.name)
                    .font(.bodyBold)
                item.ratingStars
                    .padding(.bottom, 8)
                Text("Цена")
                    .font(.caption2)
                Text(item.priceETH)
                    .font(.bodyBold)
            }
            .padding(.leading, 8)

            Spacer()

            Button(action: onDelete) {
                Image(.cartTrash)
                    .foregroundColor(.red)
                    .font(.title2)
            }
            .padding(.trailing)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

// MARK: - Preview
#Preview("Светлая тема") {
    CartItemRow(
        item: .mock1,
        onDelete: { print("Удалено") }
    )
    .padding()
    .previewLayout(.sizeThatFits)
}

#Preview("Тёмная тема") {
    CartItemRow(
        item: .mock1,
        onDelete: { print("Удалено") }
    )
    .padding()
    .previewLayout(.sizeThatFits)
    .preferredColorScheme(.dark)
}

