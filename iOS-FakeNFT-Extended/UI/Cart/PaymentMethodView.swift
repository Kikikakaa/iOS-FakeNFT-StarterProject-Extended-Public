import SwiftUI
//import Kingfisher

import SwiftUI

struct PaymentMethodView: View {
    @StateObject private var vm: PaymentMethodViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showSuccess = false
    @State private var showError = false
    @State private var errorMessage = ""

    init() {
        self._vm = StateObject(wrappedValue: PaymentMethodViewModel())
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
            VStack(spacing: 0) {
                LazyVGrid(columns: columns, spacing: 7) {
                    ForEach(vm.currencies.prefix(8)) { currency in
                        CurrencyGridItem(
                            currency: currency,
                            isSelected: vm.selectedCurrency?.id == currency.id
                        ) {
                            vm.selectedCurrency = currency
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Совершая покупку, вы соглашаетесь с условиями")
                        .font(.caption2)
                        .foregroundColor(.ypBlack)
                        .multilineTextAlignment(.leading)
                        .padding(.top)
                    
                    Text("Пользовательского соглашения")
                        .font(.caption2)
                        .foregroundColor(.blueUniversal)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 4)
                    
                    Button {
                        guard let currency = vm.selectedCurrency else { return }
                        
                        Task {
                            do {
                                try await CartViewModel.shared.clearCart()
                                
                                await MainActor.run {
                                    showSuccess = true
                                }
                            } catch {
                                await MainActor.run {
                                    errorMessage = "Ошибка оплаты"
                                    showError = true
                                }
                            }
                        }
                    } label: {
                        Text("Оплатить")
                            .font(.bodyBold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(Color.black)
                            .cornerRadius(16)
                    }
                    .disabled(vm.selectedCurrency == nil)
                    .padding(.top, 16)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .background(.lightGray)
            }
            .navigationTitle("Выберите способ оплаты")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.ypBlack)
                    }
                }
            }
            .task { await vm.loadCurrencies() }
            .fullScreenCover(isPresented: $showSuccess) {
                PaymentSuccessView(onClose: {dismiss()} )
            }
            .alert("Ошибка", isPresented: $showError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        
    }
}

#Preview {
    PaymentMethodView()
}
