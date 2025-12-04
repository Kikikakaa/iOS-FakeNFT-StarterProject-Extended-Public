import SwiftUI

struct MyNFTsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: MyNFTsViewModel
    
    // 1. Состояние для шторки сортировки
    @State private var showSortSheet = false
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.nfts.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    Text("У Вас ещё нет NFT")
                        .font(.system(size: 17, weight: .bold))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(viewModel.nfts) { nft in
                    MyNftCell(
                        nft: nft,
                        isLiked: viewModel.isLiked(nft: nft), // Проверяем лайк
                        onLikeToggle: {
                            viewModel.toggleLike(for: nft) // Переключаем
                        }
                    )
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                }
                .listStyle(.plain)
                .refreshable {
                    // Можно добавить обновление по pull-to-refresh
                    viewModel.loadData()
                }
            }
        }
        .navigationTitle("Мои NFT")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.blue)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // 2. Открываем меню по нажатию
                    showSortSheet = true
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.blue)
                }
            }
        }
        .onAppear {
            print("📱 MyNFTsView появился")
            viewModel.loadData()
        }
        // 3. Меню сортировки
        .confirmationDialog("Сортировка", isPresented: $showSortSheet, titleVisibility: .visible) {
            Button("По цене") {
                viewModel.sort(by: .price)
            }
            Button("По рейтингу") {
                viewModel.sort(by: .rating)
            }
            Button("По названию") {
                viewModel.sort(by: .name)
            }
            Button("Отмена", role: .cancel) {}
        } message: {
            Text("Выберите способ сортировки")
        }
    }
}
