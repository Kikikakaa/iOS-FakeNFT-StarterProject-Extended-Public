import SwiftUI

struct CartListView: View {
    @StateObject private var vm = CartViewModel()
    @State private var showSort = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ScrollView {
                        LazyVStack(spacing: 32) {
                            if vm.cartItems.isEmpty {
                                emptyState
                            } else {
                                ForEach(vm.cartItems) { item in
                                    CartItemRow(item: item) {
                                        Task { await vm.removeItem(item.id) }
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    
                    Spacer(minLength: 0)
                    bottomPanel
                        .ignoresSafeArea(.container, edges: .bottom)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showSort = true
                } label: {
                    Image(.sortButton)
                }
            }
        }
        .task { await vm.loadCart() }
        .overlay(loadingOverlay, alignment: .center)
        .overlay(errorOverlay, alignment: .center)
    }
    
    // MARK: - Подвиды
    @ViewBuilder
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "cart")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            Text("Корзина пуста")
                .font(.title2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }

    @ViewBuilder
    private var bottomPanel: some View {
        HStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(vm.cartItemsCount) NFT")
                        .font(.caption1)
                        
                Text(vm.total.ethFormatted)
                    .font(.bodyBold)
                    .foregroundColor(.greenUniversal)
            }
            .frame(alignment: .leading)
            
            Button("К оплате") {
                // Переход к оплате
            }
            .font(.bodyBold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(Color.black)
            .cornerRadius(16)
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
        .background(.lightGray)
//        .clipShape(
//            .rect(
//                topLeadingRadius: 12,
//                bottomLeadingRadius: 0,
//                bottomTrailingRadius: 0,
//                topTrailingRadius: 12
//                )
//            )
    }

    @ViewBuilder
    private var loadingOverlay: some View {
        if vm.isLoading {
            ZStack {
                Color.black.opacity(0.3).ignoresSafeArea()
                ProgressView("Загрузка...")
                    .padding()
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    @ViewBuilder
    private var errorOverlay: some View {
        if let error = vm.errorMessage {
            VStack(spacing: 12) {
                Text("Ошибка").font(.headline).foregroundColor(.red)
                Text(error).multilineTextAlignment(.center)
                Button("Повторить") {
                    Task { await vm.loadCart() }
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            .padding()
        }
    }
}

#Preview {
    CartListView()
}
