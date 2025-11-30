import Kingfisher
import SwiftUI

struct CartItemRow: View {
    let item: NFTItem
    let onDelete: () -> Void

    var body: some View {
        HStack {
            nftImage

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

    var nftImage: some View {
        KFImage(URL(string: item.imageUrl))
            .placeholder {
                Color.gray.frame(
                    width: UIConstants.nftImageWidthHeight,
                    height: UIConstants.nftImageWidthHeight
                )
            }
            .resizable()
            .scaledToFill()
            .frame(
                width: UIConstants.nftImageWidthHeight,
                height: UIConstants.nftImageWidthHeight
            )
            .clipped()
            .cornerRadius(12)
    }
}

// MARK: - Preview
#Preview() {
    CartItemRow(
        item: .mock1,
        onDelete: { print("Удалено") }
    )
    .padding()
    .previewLayout(.sizeThatFits)
}
