import SwiftUI

struct ProfileEditView: View {
    @StateObject var viewModel: ProfileEditViewModel
    @Binding var isPresented: Bool
    
    init(profile: ProfileModel?, service: ProfileService, isPresented: Binding<Bool>, onUpdate: @escaping (ProfileModel) -> Void) {
        self._isPresented = isPresented
        let vm = ProfileEditViewModel(profile: profile, service: service)
        vm.onProfileUpdated = onUpdate
        self._viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground).ignoresSafeArea()
            
            VStack(spacing: 24) {
                headerView
                avatarView
                fieldsView
                Spacer()
                saveButton
            }
        }
        // 1. Алерт выхода
        .alert("Уверены, что хотите выйти?", isPresented: $viewModel.isShowingExitAlert) {
            Button("Остаться", role: .cancel) { }
            Button("Выйти") { isPresented = false }
        }
        
        // 2. Шторка (ActionSheet)
        .actionSheet(isPresented: $viewModel.isShowingImagePickerActionSheet) {
            ActionSheet(
                title: Text("Фото профиля"),
                buttons: [
                    .default(Text("Изменить фото")) {
                        viewModel.isShowingUrlInputAlert = true
                    },
                    .destructive(Text("Удалить фото")) {
                        viewModel.deleteAvatar()
                    },
                    .cancel(Text("Отмена"))
                ]
            )
        }
        
        // 3. Алерт для ввода ссылки (вызывается из шторки)
        .alert("Ссылка на фото", isPresented: $viewModel.isShowingUrlInputAlert) {
            TextField("URL", text: $viewModel.avatarUrlInput)
            Button("Сохранить") { viewModel.updateAvatar(from: viewModel.avatarUrlInput) }
            Button("Отмена", role: .cancel) { }
        }
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        HStack {
            Button {
                if viewModel.hasChanges {
                    viewModel.isShowingExitAlert = true
                } else {
                    isPresented = false
                }
            } label: {
                Image("Backward")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(Color(uiColor: .label))
                    .padding(.leading, 16)
                    .padding(.top, 16)
            }
            Spacer()
        }
    }
    
    private var avatarView: some View {
        Button {
            viewModel.isShowingImagePickerActionSheet = true
        } label: {
            ZStack(alignment: .bottomTrailing) {
                
                // 1. Основная аватарка
                AsyncImage(url: viewModel.avatarURL) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable().foregroundStyle(.gray)
                }
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                
                // 2. Кружок с камерой поверх аватарки
                Image("Union")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .padding(8)
                    .background(Color(uiColor: UIColor(hexString: "F7F7F8")))
                    .clipShape(Circle())
                    .offset(x: 4, y: 4)
            }
        }
    }
    
    private var fieldsView: some View {
        ScrollView {
            VStack(spacing: 24) {
                makeTextField(title: "Имя", text: $viewModel.name)
                makeTextField(title: "Описание", text: $viewModel.description, axis: .vertical)
                makeTextField(title: "Сайт", text: $viewModel.website)
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func makeTextField(title: String, text: Binding<String>, axis: Axis = .horizontal) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color(uiColor: .label))
            
            TextField("", text: text, axis: axis)
                .font(.system(size: 17, weight: .regular))
                .kerning(-0.41)
                .padding(16)
                .background(Color(uiColor: UIColor(hexString: "F7F7F8")))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.clear, lineWidth: 0)
                )
                .lineLimit(axis == .vertical ? 3...6 : 1...1)
                .autocapitalization(.none)
        }
    }
    
    private var saveButton: some View {
        Group {
            if viewModel.hasChanges {
                Button {
                    Task {
                        if await viewModel.saveProfile() {
                            isPresented = false
                        }
                    }
                } label: {
                    if viewModel.isLoading {
                        ProgressView().tint(Color(uiColor: .systemBackground))
                    } else {
                        Text("Сохранить").font(.system(size: 17, weight: .bold))
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color(uiColor: .label))
                .foregroundStyle(Color(uiColor: .systemBackground))
                .cornerRadius(16)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .animation(.easeInOut, value: viewModel.hasChanges)
    }
}
