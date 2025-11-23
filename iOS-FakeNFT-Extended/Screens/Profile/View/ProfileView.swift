import SwiftUI

struct ProfileView: View {
    // 1. Создаем ViewModel сами (StateObject)
    @StateObject private var viewModel = ProfileViewModel()
    
    // 2. Получаем сервисы из Environment (без init!)
    @Environment(ServicesAssembly.self) private var servicesAssembly
    
    @State private var isShowingEditSheet = false
    
    var body: some View {
        NavigationView {
            // 3. Используем .zero
            VStack(spacing: .zero) {
                if let profile = viewModel.profile {
                    // Код стал чистым — вызываем функции-строители
                    headerView(profile: profile)
                    listView(profile: profile)
                } else {
                    ProgressView()
                }
            }
            .background(Color(uiColor: .systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                editButton
            }
        }
        .sheet(isPresented: $isShowingEditSheet) {
            Text("Edit Profile View Stub")
        }
    }
    
    // MARK: - Private Subviews
    
    // Вынесли создание хедера
    private func headerView(profile: ProfileModel) -> some View {
        ProfileHeaderView(profile: profile)
            .padding(.horizontal, 16)
            .padding(.top, 20)
    }
    
    // Вынесли создание списка
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
    
    // Вынесли кнопку редактирования
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
