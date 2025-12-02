import SwiftUI

struct FavoriteNFTsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: FavoriteNFTsViewModel
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.nfts.isEmpty {
                Text("У Вас ещё нет избранных NFT")
                    .font(.system(size: 17, weight: .bold))
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.nfts) { nft in
                            FavoriteNftCell(
                                nft: nft,
                                onUnlike: {
                                    viewModel.unlikeNft(nft: nft)
                                }
                            )
                        }
                    }
                    .padding(16)
                }
            }
        }
        .navigationTitle("Избранные NFT")
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
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}
