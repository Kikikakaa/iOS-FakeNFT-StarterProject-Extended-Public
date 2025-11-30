import SwiftUI

struct RatingView: View {
    let rating: Int
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 12, height: 12)
                    // Если индекс меньше или равен рейтингу - красим в желтый, иначе в серый
                    .foregroundStyle(index <= rating ? Color.yellow : Color.gray.opacity(0.3))
            }
        }
    }
}
