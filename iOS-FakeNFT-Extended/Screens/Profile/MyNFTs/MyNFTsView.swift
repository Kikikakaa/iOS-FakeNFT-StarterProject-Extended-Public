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
            } else if viewModel.nfts.isEmpty {
                Text("У Вас ещё нет NFT")
                    .font(.system(size: 17, weight: .bold))
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
            }
        }
        .navigationTitle("Мои NFT")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image("Backward")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color(uiColor: .label))
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // 2. Открываем меню по нажатию
                    showSortSheet = true
                } label: {
                    Image("Sort")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color(uiColor: .label))
                }
            }
        }
        .onAppear {
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
            Button("Закрыть", role: .cancel) {}
        }
    }
}
