import SwiftUI

struct ProfileView: View {
    @StateObject private var favoritesService = FavoritesService.shared
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(ServicesAssembly.self) private var servicesAssembly
    @State private var favoritesCount = "(0)"
    
    // Состояния навигации
    @State private var isShowingEditSheet = false
    @State private var isShowingWebView = false
    @State private var webViewURL: URL?
    
    var body: some View {
        NavigationView {
            VStack(spacing: .zero) {
                if viewModel.isLoading {
                    ProgressView()
                }
                else if let profile = viewModel.profile {
                    headerView(profile: profile)
                    listView(profile: profile)
                    
                    // Скрытая ссылка для перехода на WebView
                    NavigationLink(
                        isActive: $isShowingWebView,
                        destination: {
                            if let url = webViewURL {
                                AboutView(url: url)
                            }
                        },
                        label: { EmptyView() }
                    )
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
            updateFavoritesCount()
        }
        .onReceive(favoritesService.$favorites) { newFavorites in
            // Реагируем на изменения в сервисе
            updateFavoritesCount()
        }
        .onReceive(NotificationCenter.default.publisher(for: .favoritesDidChange)) { _ in
            // Дублирующая подписка для гарантии
            updateFavoritesCount()
        }
        .fullScreenCover(isPresented: $isShowingEditSheet) {
            ProfileEditView(
                profile: viewModel.profile,
                service: servicesAssembly.profileService,
                isPresented: $isShowingEditSheet,
                onUpdate: { updatedProfile in
                    viewModel.profile = updatedProfile
                }
            )
        }
    }
    
    // MARK: - Private Subviews
    
    private func headerView(profile: ProfileModel) -> some View {
        ProfileHeaderView(
            profile: profile,
            onWebsiteTap: { url in
                // Открываем сайт Практикума (по ТЗ)
                if let practicumURL = URL(string: "https://practicum.yandex.ru/ios-developer/") {
                    self.webViewURL = practicumURL
                    self.isShowingWebView = true
                }
            }
        )
    }
    
    private func listView(profile: ProfileModel) -> some View {
        List {
            Section {
                // 1. Кнопка "Мои NFT"
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
                
                // 2. Кнопка "Избранные NFT"
                ZStack(alignment: .leading) {
                    NavigationLink(destination:
                                    FavoriteNFTsView(
                                        viewModel: FavoriteNFTsViewModel(
                                            nftService: servicesAssembly.nftService
                                        )
                                    )
                    ) {
                        EmptyView()
                    }
                    .opacity(0)
                    
                    ProfileListRow(
                        title: NSLocalizedString("Profile.favorites", comment: ""),
                        count: favoritesCount
                    )
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .onAppear {
            updateFavoritesCount()
        }
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
    
    private func updateFavoritesCount() {
        let count = favoritesService.getFavoriteNFTs().count
        favoritesCount = "(\(count))"
    }
}

extension Notification.Name {
    static let favoritesDidChange = Notification.Name("favoritesDidChange")
}
