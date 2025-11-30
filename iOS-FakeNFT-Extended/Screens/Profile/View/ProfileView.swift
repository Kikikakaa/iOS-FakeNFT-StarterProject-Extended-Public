import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(ServicesAssembly.self) private var servicesAssembly
    
    @State private var isShowingEditSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: .zero) {
                if viewModel.isLoading {
                    ProgressView()
                }
                else if let profile = viewModel.profile {
                    headerView(profile: profile)
                    listView(profile: profile)
                }
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
        .onAppear {
            viewModel.loadProfile(service: servicesAssembly.profileService)
        }
        .fullScreenCover(isPresented: $isShowingEditSheet) {
            ProfileEditView(
                profile: viewModel.profile,               // 1. Передаем текущие данные
                service: servicesAssembly.profileService, // 2. Передаем сервис
                isPresented: $isShowingEditSheet,         // 3. Биндинг для закрытия
                onUpdate: { updatedProfile in             // 4. Что делать, когда сохранили
                    // Обновляем данные на главном экране мгновенно
                    viewModel.profile = updatedProfile
                }
            )
        }
    }
    
    // MARK: - Private Subviews
    
    private func headerView(profile: ProfileModel) -> some View {
        ProfileHeaderView(profile: profile)
            .padding(.top, 20)
    }
    
    private func listView(profile: ProfileModel) -> some View {
            List {
                Section {
                    // --- Мои NFT ---
                    ZStack(alignment: .leading) {
                        NavigationLink(destination:
                            MyNFTsView(
                                viewModel: MyNFTsViewModel(
                                    profile: profile,
                                    nftService: servicesAssembly.nftService,
                                    profileService: servicesAssembly.profileService,
                                    onProfileUpdate: { updatedProfile in
                                        viewModel.profile = updatedProfile
                                    }
                                )
                            )
                        ) {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        ProfileListRow(
                            title: NSLocalizedString("Profile.myNFTs", comment: ""),
                            count: profile.nftsCount
                        )
                    }
                    .listRowSeparator(.hidden)
                    
                    // --- Избранные NFT ---
                    ZStack(alignment: .leading) {
                        NavigationLink(destination:
                            FavoriteNFTsView(
                                viewModel: FavoriteNFTsViewModel(
                                    profile: profile,
                                    nftService: servicesAssembly.nftService,
                                    profileService: servicesAssembly.profileService,
                                    onProfileUpdate: { updatedProfile in // <--- Ловим обновление
                                        viewModel.profile = updatedProfile
                                    }
                                )
                            )
                        ) {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        ProfileListRow(
                            title: NSLocalizedString("Profile.favorites", comment: ""),
                            count: profile.likesCount
                        )
                    }
                    .listRowSeparator(.hidden)
                }
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
