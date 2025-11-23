import SwiftUI

struct ProfileEditView: View {
    @ObservedObject var viewModel: ProfileViewModel
    let profileService: ProfileService
    @Binding var isPresented: Bool
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var website: String = ""
    @State private var avatarURL: URL?
    
    // Состояние для алерта смены URL
    @State private var isShowingUrlAlert = false
    @State private var avatarUrlInput = ""
    
    // Состояние для алерта выхода
    @State private var isShowingExitAlert = false
    
    private var hasChanges: Bool {
        guard let profile = viewModel.profile else { return false }
        return name != profile.name ||
        description != profile.description ||
        website != (profile.websiteURL?.absoluteString ?? "") ||
        avatarURL != profile.avatarURL
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // --- Верхняя панель ---
                HStack {
                    Button {
                        // ЛОГИКА ВЫХОДА
                        if hasChanges {
                            isShowingExitAlert = true
                        } else {
                            isPresented = false
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color(uiColor: .label))
                            .font(.system(size: 24, weight: .bold))
                            .padding(12)
                    }
                    Spacer()
                }
                .padding(.horizontal, 4)
                
                // --- Аватарка с кнопкой ---
                Button {
                    isShowingUrlAlert = true
                } label: {
                    ZStack {
                        AsyncImage(url: avatarURL) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .foregroundStyle(.gray)
                        }
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        
                        Color.black.opacity(0.6)
                            .clipShape(Circle())
                            .frame(width: 70, height: 70)
                        
                        Text("Изменить\nфото")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                    }
                }
                
                // --- Поля ввода ---
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Имя")
                                .font(.headline)
                            TextField("Введите имя", text: $name)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Описание")
                                .font(.headline)
                            TextField("Расскажите о себе", text: $description, axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                                .lineLimit(3...6)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Сайт")
                                .font(.headline)
                            TextField("Ссылка на сайт", text: $website)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.URL)
                                .autocapitalization(.none)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                
                Spacer()
                
                // --- Кнопка Сохранить ---
                if hasChanges {
                    Button {
                        saveProfile()
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(Color(uiColor: .systemBackground))
                        } else {
                            Text("Сохранить")
                                .font(.system(size: 17, weight: .bold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color(uiColor: .label))
                    .foregroundStyle(Color(uiColor: .systemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    .transition(.opacity)
                }
            }
        }
        .onAppear {
            if let currentProfile = viewModel.profile {
                self.name = currentProfile.name
                self.description = currentProfile.description
                self.website = currentProfile.websiteURL?.absoluteString ?? ""
                self.avatarURL = currentProfile.avatarURL
            }
        }
        .animation(.easeInOut, value: hasChanges)
        
        // Алерт для смены фото
        .alert("Введите ссылку на фото", isPresented: $isShowingUrlAlert) {
            TextField("URL", text: $avatarUrlInput)
            Button("ОК") {
                if let url = URL(string: avatarUrlInput), !avatarUrlInput.isEmpty {
                    self.avatarURL = url
                }
            }
            Button("Отмена", role: .cancel) {}
        }
        
        // Алерт для подтверждения выхода
        .alert("Уверены, что хотите выйти?", isPresented: $isShowingExitAlert) {
            // Кнопка "Остаться" - роль .cancel
            Button("Остаться", role: .cancel) { }
            Button("Выйти") {
                isPresented = false
            }
        }
    }
    
    private func saveProfile() {
        viewModel.updateProfile(
            service: profileService,
            newName: name,
            newDescription: description,
            newWebsite: website,
            newAvatar: avatarURL
        )
        isPresented = false
    }
}
