import Foundation
import Combine

final class ProfileViewModel: ObservableObject {
    
    // Обновили тип данных
    @Published var profile: ProfileModel?
    
    init() {
        loadMockProfile()
    }
    
    private func loadMockProfile() {
        // Создаем ProfileModel вместо ProfileUIModel
        self.profile = ProfileModel(
            avatarURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Joaquin%20Phoenix.png"),
            name: "Joaquin Phoenix",
            description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
            websiteURL: URL(string: "https://practicum.yandex.ru"),
            nftsCount: "(112)",
            likesCount: "(11)"
        )
    }
}
