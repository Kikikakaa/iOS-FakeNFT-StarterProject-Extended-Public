import SwiftUI
import Kingfisher

struct CurrencyGridItem: View {
    let currency: Currency
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            
            HStack(spacing: 4) {
                
                KFImage(URL(string: currency.imageUrl))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(currency.title)
                        .font(.caption2)
                        .foregroundColor(.primary)
                    
                    Text(currency.displayName)
                        .font(.caption2)
                        .foregroundColor(.greenUniversal)
                        .padding(.top, 2)
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, maxHeight: 46, alignment: .leading)
            .background(.lightGray)
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    CurrencyGridItem(
        currency: Currency.mockCurrencies[0],
        isSelected: true,
        onTap: {}
    )
    .padding()
}
