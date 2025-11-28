import Foundation
import SwiftUI

@MainActor
final class ProfileEditViewModel: ObservableObject {
    
    // Данные для редактирования
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var website: String = ""
    @Published var avatarURL: URL?
    
    // Состояния UI
    @Published var isLoading: Bool = false
    @Published var isShowingExitAlert: Bool = false
    
    // Состояния для смены фото
    @Published var isShowingImagePickerActionSheet: Bool = false // Для шторки
    @Published var isShowingUrlInputAlert: Bool = false          // Для ввода URL
    @Published var avatarUrlInput: String = ""
    
    private let originalProfile: ProfileModel?
    private let profileService: ProfileService
    
    // Callback для обновления данных на главном экране
    var onProfileUpdated: ((ProfileModel) -> Void)?
    
    init(profile: ProfileModel?, service: ProfileService) {
        self.originalProfile = profile
        self.profileService = service
        
        if let profile = profile {
            self.name = profile.name
            self.description = profile.description
            self.website = profile.websiteURL?.absoluteString ?? ""
            self.avatarURL = profile.avatarURL
        }
    }
    
    // Есть ли изменения
    var hasChanges: Bool {
        guard let original = originalProfile else { return false }
        return name != original.name ||
        description != original.description ||
        website != (original.websiteURL?.absoluteString ?? "") ||
        avatarURL != original.avatarURL
    }
    
    // Обновление аватара из строки URL
    func updateAvatar(from string: String) {
        if let url = URL(string: string), !string.isEmpty {
            self.avatarURL = url
        }
    }
    
    // Метод удаления аватарки
    func deleteAvatar() {
        self.avatarURL = nil
    }
    
    // Сохранение
    func saveProfile() async -> Bool {
        guard let original = originalProfile else { return false }
        isLoading = true
        
        let updatedModel = ProfileModel(
            avatarURL: avatarURL,
            name: name,
            description: description,
            websiteURL: URL(string: website),
            nftsCount: original.nftsCount,
            likesCount: original.likesCount
        )
        
        do {
            let result = try await profileService.updateProfile(model: updatedModel)
            onProfileUpdated?(result)
            isLoading = false
            return true
        } catch {
            print("Ошибка сохранения: \(error)")
            isLoading = false
            return false
        }
    }
}
