import SwiftUI

struct PaymentSuccessView: View {
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 32) {
           Spacer()
            
            Image(.paymentSuccess)
                .resizable()
                .scaledToFit()
                .frame(width: 278, height: 278)
            
            Text("Успех! Оплата прошла,\nпоздравляем с покупкой!")
                .font(.headline3)
                .foregroundStyle(.ypBlack)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        
        Spacer()
        
        Button("Вернуться в корзину") {
            onClose()
        }
        .font(.bodyBold)
        .foregroundColor(.ypWhite)
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(.ypBlack)
        .cornerRadius(16)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}



#Preview {
    PaymentSuccessView {}
}
