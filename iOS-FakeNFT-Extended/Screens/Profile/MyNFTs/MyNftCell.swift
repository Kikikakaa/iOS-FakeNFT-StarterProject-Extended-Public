import SwiftUI
import Kingfisher

struct MyNftCell: View {
    let nft: Nft
    let isLiked: Bool
    let onLikeToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: nft.images.first) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFit()
                    case .failure:
                        Color.gray.opacity(0.2)
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 108, height: 108)
                .cornerRadius(12)
                .clipped()
                
                // Кнопка Лайка
                Button {
                    onLikeToggle()
                } label: {
                    Image(isLiked ? .active : .noActiveLike)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 42, height: 42)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(nft.name)
                    .font(.system(size: 17, weight: .bold))
                    .lineLimit(1)
                
                RatingView(rating: nft.rating)
                
                Spacer().frame(height: 4)
                
                Text("от \(nft.author)")
                    .font(.system(size: 13, weight: .regular))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Цена")
                    .font(.system(size: 13, weight: .regular))
                Text("\(String(format: "%.2f", nft.price)) ETH")
                    .font(.system(size: 17, weight: .bold))
            }
        }
        .padding(.vertical, 16)
        .padding(.trailing, 20)
    }
}
