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
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.nfts.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    Text("У Вас ещё нет избранных NFT")
                        .font(.system(size: 17, weight: .bold))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        }
        .onAppear {
            viewModel.loadData()
        }
    }
}
