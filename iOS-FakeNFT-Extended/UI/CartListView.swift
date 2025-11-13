//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by user on 13.11.2025.
//

import SwiftUI

struct CartListView: View {
    @StateObject private var vm = CartViewModel()

        var body: some View {
            NavigationView {
                Group {
                    if vm.isLoading {
                        ProgressView("Загрузка...")
                    } else if let error = vm.errorMessage {
                        VStack {
                            Text("Ошибка").foregroundColor(.red)
                            Text(error)
                            Button("Повторить") { Task { await vm.loadCart() } }
                        }
                    } else if vm.cartItems.isEmpty {
                        Text("Корзина пуста")
                    } else {
                        List {
                            ForEach(vm.cartItems) { item in
                                CartItemRow(item: item) {
                                    Task { await vm.removeItem(item.id) }
                                }
                            }
                            
                            Section {
                                HStack {
                                    Text("Итого:")
                                    Spacer()
                                    Text(vm.total.ethFormatted).bold()
                                }
                                Button("К оплате") { }
                                    .buttonStyle(.borderedProminent)
                            }
                        }
                    }
                }
                .task { await vm.loadCart() }
            }
        }
}

#Preview {
    CartListView()
}
