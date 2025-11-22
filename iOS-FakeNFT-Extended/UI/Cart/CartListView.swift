import SwiftUI

struct CartListView: View {
    @StateObject private var vm = CartViewModel()
    @State private var showSort = false
    @State private var itemToDelete: NFTItem? = nil
    
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
                                ForEach(vm.sortedCartItems) { item in
                                    CartItemRow(item: item) {
                                        itemToDelete = item
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
            if vm.cartItems.count >= 2 {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSort = true
                    } label: {
                        Image(.sortButton)
                    }
                }
            }
        }
        .toolbar(itemToDelete != nil ? .hidden : .visible, for: .navigationBar, .tabBar)
        .task { await vm.loadCart() }
        .overlay(loadingOverlay, alignment: .center)
        .overlay(errorOverlay, alignment: .center)
        .overlay(deleteOverlay)
        .overlay(sortOverlay)
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
            .background(.ypBlack)
            .cornerRadius(16)
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
        .background(.lightGray)
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
    
    @ViewBuilder
    private var deleteOverlay: some View {
        if let item = itemToDelete {
            ZStack {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()

                VStack(spacing: 12) {

                    if let url = URL(string: item.imageUrl) {
                        AsyncImage(url: url) { img in
                            img.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(maxWidth: UIConstants.nftImageWidthHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Text("Вы уверены, что хотите\nудалить объект из корзины?")
                        .multilineTextAlignment(.center)
                        .font(.caption2)
                        .foregroundColor(.primary)
                        .padding(.bottom, 8)

                    HStack(spacing: 8) {
                        Button {
                            Task {
                                await vm.removeItem(item.id)
                                itemToDelete = nil
                            }
                        } label: {
                            Text("Удалить")
                                .foregroundColor(.red)
                                .font(.bodyRegular)
                                .frame(maxWidth: 127, minHeight: 44)
                                .background(.ypBlack)
                                .cornerRadius(12)
                        }

                        Button {
                            itemToDelete = nil
                        } label: {
                            Text("Вернуться")
                                .foregroundColor(.white)
                                .font(.bodyRegular)
                                .frame(maxWidth: 127, minHeight: 44)
                                .background(.ypBlack)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .transition(.opacity)
        }
    }
    
    @ViewBuilder
    private var sortOverlay: some View {
        if showSort {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showSort = false
                        }
                    }
                
                VStack(spacing: 0) {
                    
                    VStack(spacing: 0) {
                        Text("Сортировка")
                            .font(.system(size: 13, weight: .regular))
                            .padding(.vertical, 12)
                            .foregroundColor(.grayUniversal)
                        
                        Divider()
                        
                        VStack(spacing: 0) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Button {
                                    withAnimation {
                                        vm.sortOption = option
                                        showSort = false
                                    }
                                } label: {
                                    HStack {
                                        Text(option.title)
                                            .font(.system(size: 20))
                                            .foregroundColor(.blueUniversal)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 60)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                if option != SortOption.allCases.last {
                                    Divider()
                                }
                            }
                        }
                    }
                    .background(.thinMaterial)
                    .cornerRadius(12)
                    .padding(.horizontal, 8)
                    
                    Spacer().frame(height: 8)
                    
                    Button {
                        withAnimation {
                            showSort = false
                        }
                    } label: {
                        Text("Закрыть")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.blueUniversal)
                            .frame(maxWidth: .infinity, minHeight: 60)
                            .background(.ypWhite)
                            .cornerRadius(12)
                            .padding(.horizontal, 8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.bottom, 16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            .transition(.opacity.combined(with: .move(edge: .bottom)))
            .zIndex(1000)
        }
    }
}

#Preview {
    CartListView()
}
