import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(ServicesAssembly.self) private var servicesAssembly
    
    @State private var isShowingEditSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: .zero) {
                // 1. Если идет загрузка — крутим спиннер
                if viewModel.isLoading {
                    ProgressView()
                }
                // 2. Если загрузка кончилась и есть данные — показываем профиль
                else if let profile = viewModel.profile {
                    headerView(profile: profile)
                    listView(profile: profile)
                }
                // 3. Если ни того, ни другого (например, ошибка) — пустота или текст ошибки
                else {
                    Text("Не удалось загрузить профиль")
                        .foregroundStyle(.gray)
                }
            }
            .background(Color(uiColor: .systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                editButton
            }
        }
        // 4. Как только экран появился — качаем данные
        .onAppear {
            // Передаем сервис прямо из Environment
            viewModel.loadProfile(service: servicesAssembly.profileService)
        }
                .fullScreenCover(isPresented: $isShowingEditSheet) {
                    ProfileEditView(
                        viewModel: viewModel,
                        profileService: servicesAssembly.profileService,
                        isPresented: $isShowingEditSheet
                    )
                }
    }
    
    // MARK: - Private Subviews
    
    private func headerView(profile: ProfileModel) -> some View {
        ProfileHeaderView(profile: profile)
            .padding(.horizontal, 16)
            .padding(.top, 20)
    }
    
    private func listView(profile: ProfileModel) -> some View {
        List {
            Section {
                NavigationLink(destination: Text(NSLocalizedString("Profile.myNFTs", comment: ""))) {
                    ProfileListRow(
                        title: NSLocalizedString("Profile.myNFTs", comment: ""),
                        count: profile.nftsCount
                    )
                }
                
                NavigationLink(destination: Text(NSLocalizedString("Profile.favorites", comment: ""))) {
                    ProfileListRow(
                        title: NSLocalizedString("Profile.favorites", comment: ""),
                        count: profile.likesCount
                    )
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
    
    private var editButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                isShowingEditSheet = true
            } label: {
                Image(systemName: "square.and.pencil")
                    .tint(Color(uiColor: .label))
            }
        }
    }
}
