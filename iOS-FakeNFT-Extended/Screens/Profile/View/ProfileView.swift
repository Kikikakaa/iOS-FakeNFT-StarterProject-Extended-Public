import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(ServicesAssembly.self) private var servicesAssembly
    
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
