import Foundation

@MainActor
final class MyNFTsViewModel: ObservableObject {
    
    @Published var nfts: [Nft] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published private var profile: ProfileModel
    
    private let profileService: ProfileService
    private let nftService: NftService
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
        guard nfts.isEmpty else { return }
        isLoading = true
        
        Task {
            do {
                var loadedNfts: [Nft] = []
                // Берем ID из профиля
                for id in profile.nfts {
                    let nft = try await nftService.loadNft(id: id)
                    loadedNfts.append(nft)
                }
                // Сортировка по умолчанию (рейтинг)
                self.nfts = loadedNfts.sorted { $0.rating > $1.rating }
                self.isLoading = false
            } catch {
                print("Ошибка: \(error)")
                self.error = error
                self.isLoading = false
            }
        }
    }
    
    func toggleLike(for nft: Nft) {
        let isLiked = profile.likes.contains(nft.id)
                var newLikes = profile.likes
        if isLiked {
            newLikes.removeAll { $0 == nft.id } // Удаляем
        } else {
            newLikes.append(nft.id) // Добавляем
        }
        
        let updatedProfile = ProfileModel(
            avatarURL: profile.avatarURL,
            name: profile.name,
            description: profile.description,
            websiteURL: profile.websiteURL,
            nftsCount: profile.nftsCount,
            likesCount: "(\(newLikes.count))", // Обновляем счетчик
            nfts: profile.nfts,
            likes: newLikes
        )
        
        self.profile = updatedProfile
        
        onProfileUpdate(updatedProfile)
        
        Task {
            do {
                let _ = try await profileService.updateProfile(model: updatedProfile)
            } catch {
                print("Ошибка обновления лайка: \(error)")
            }
        }
    }
    
    // Проверка, лайкнут ли NFT
    func isLiked(nft: Nft) -> Bool {
        return profile.likes.contains(nft.id)
    }
    
    enum SortOption {
        case price, rating, name
    }
    
    func sort(by option: SortOption) {
        switch option {
        case .price: nfts.sort { $0.price < $1.price }
        case .rating: nfts.sort { $0.rating > $1.rating }
        case .name: nfts.sort { $0.name < $1.name }
        }
    }
}
