import SwiftUI
import Kingfisher

struct CartItemRow: View {
    let item: NFTItem
    let onDelete: () -> Void

    var body: some View {
        HStack {
            KFImage(URL(string: item.imageUrl))
                .placeholder { Color.gray.frame(width: 60, height: 60) }
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipped()
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(item.name).font(.headline)
                Text(item.ratingStars)
                Text(item.priceETH).foregroundColor(.secondary)
            }

            Spacer()

            Button(action: onDelete) {
                Image(systemName: "trash").foregroundColor(.red)
            }
        }
    }
}

