import Foundation

@MainActor
final class FavoriteNFTsViewModel: ObservableObject {
    
    @Published var nfts: [Nft] = []
    @Published var isLoading: Bool = false
    
    private var profile: ProfileModel
    private let nftService: NftService
    private let profileService: ProfileService
    private let onProfileUpdate: (ProfileModel) -> Void
    
    init(
            profile: ProfileModel,
            nftService: NftService,
            profileService: ProfileService,
            onProfileUpdate: @escaping (ProfileModel) -> Void
        ) {
            self.profile = profile
            self.nftService = nftService
            self.profileService = profileService
            self.onProfileUpdate = onProfileUpdate
        }
    
    func loadData() {
        isLoading = true
        Task {
            do {
                var loadedNfts: [Nft] = []
                for id in profile.likes {
                    let nft = try await nftService.loadNft(id: id)
                    loadedNfts.append(nft)
                }
                self.nfts = loadedNfts.sorted { $0.name < $1.name }
                self.isLoading = false
            } catch {
                print(error)
                self.isLoading = false
            }
        }
    }
    
    // Удаление из избранного
    func unlikeNft(nft: Nft) {
        nfts.removeAll { $0.id == nft.id }
        
        // Обновляем модель профиля
        var newLikes = profile.likes
        newLikes.removeAll { $0 == nft.id }
        
        let updatedProfile = ProfileModel(
            avatarURL: profile.avatarURL,
            name: profile.name,
            description: profile.description,
            websiteURL: profile.websiteURL,
            nftsCount: profile.nftsCount,
            likesCount: "(\(newLikes.count))",
            nfts: profile.nfts,
            likes: newLikes
        )
        self.profile = updatedProfile
        onProfileUpdate(updatedProfile)
        
        // Шлем на сервер
        Task {
            try? await profileService.updateProfile(model: updatedProfile)
        }
    }
}
