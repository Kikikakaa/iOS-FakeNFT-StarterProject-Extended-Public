import SwiftUI
import Kingfisher

struct FavoriteNftCell: View {
    let nft: Nft
    let onUnlike: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            
            // 1. Картинка (Слева)
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: nft.images.first) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure:
                        Color.gray.opacity(0.2)
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 80, height: 80) // Строго квадрат 80x80
                .cornerRadius(12)
                .clipped()
                
                // Кнопка "Active"
                Button {
                    onUnlike()
                } label: {
                    Image("Active")
                        .resizable()
                        .frame(width: 42, height: 42)
                }
                .padding([.top, .trailing], -6)
            }
            
            // 2. Инфо (Справа)
            VStack(alignment: .leading, spacing: 4) {
                Text(nft.name)
                    .font(.system(size: 17, weight: .bold))
                    .lineLimit(1)
                
                RatingView(rating: nft.rating)
                
                Spacer().frame(height: 4)
                
                Text("\(String(format: "%.2f", nft.price)) ETH")
                    .font(.system(size: 15, weight: .regular))
            }
            
            Spacer()
        }
    }
}
