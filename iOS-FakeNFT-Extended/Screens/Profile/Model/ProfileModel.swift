import Foundation

/// Модель данных профиля пользователя, отображаемая на UI
struct ProfileModel {
    /// Ссылка на картинку аватара (может отсутствовать, тогда ставим заглушку)
    let avatarURL: URL?
    
    /// Имя пользователя
    let name: String
    
    /// Текстовое описание профиля / Биография
    let description: String
    
    /// Ссылка на веб-сайт пользователя (опционально)
    let websiteURL: URL?
    
    /// Количество NFT в коллекции (строкой, напр. "(112)")
    let nftsCount: String
    
    /// Количество лайкнутых NFT (строкой, напр. "(11)")
    let likesCount: String
}
