import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published var profile: ProfileModel?
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    func loadProfile(service: ProfileService) {
        isLoading = true
        Task {
            do {
                let profile = try await service.loadProfile()
                self.profile = profile
                self.isLoading = false
            } catch {
                print("[ProfileViewModel] Ошибка загрузки: \(error)")
                self.error = error
                self.isLoading = false
            }
        }
    }
    
    func updateProfile(
        service: ProfileService,
        newName: String,
        newDescription: String,
        newWebsite: String,
        newAvatar: URL?
    ) {
        guard let currentProfile = profile else { return }
        
        let updatedModel = ProfileModel(
            avatarURL: newAvatar,
            name: newName,
            description: newDescription,
            websiteURL: URL(string: newWebsite),
            nftsCount: currentProfile.nftsCount,
            likesCount: currentProfile.likesCount
        )
        
        isLoading = true
        
        Task {
            do {
                // Отправляем на сервер
                let resultProfile = try await service.updateProfile(model: updatedModel)
                
                // Если ок - обновляем UI
                self.profile = resultProfile
                self.isLoading = false
            } catch {
                print("[ProfileViewModel] Ошибка обновления: \(error)")
                self.error = error
                self.isLoading = false
            }
        }
    }
}
