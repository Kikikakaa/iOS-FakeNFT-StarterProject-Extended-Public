import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @Environment(ServicesAssembly.self) private var servicesAssembly
    @State private var isShowingEditSheet = false
    
    init(servicesAssembly: ServicesAssembly) {
        self._viewModel = StateObject(wrappedValue: ProfileViewModel())
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if let profile = viewModel.profile {
                    ProfileHeaderView(profile: profile)
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                    
                    List {
                        Section {
                            NavigationLink(destination: Text("Экран Мои NFT")) {
                                ProfileListRow(title: "Мои NFT", count: profile.nftsCount)
                            }
                            
                            NavigationLink(destination: Text("Экран Избранные NFT")) {
                                ProfileListRow(title: "Избранные NFT", count: profile.likesCount)
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    
                } else {
                    ProgressView()
                }
            }
            .background(Color(uiColor: .systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
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
        .sheet(isPresented: $isShowingEditSheet) {
            Text("Здесь будет редактирование профиля")
        }
    }
}

// MARK: - Subviews
struct ProfileHeaderView: View {
    let profile: ProfileUIModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            AsyncImage(url: profile.avatarURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundStyle(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 70, height: 70)
            .clipShape(Circle())
            
            Text(profile.name)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color(uiColor: .label))
            
            Spacer()
        }
        
        VStack(alignment: .leading, spacing: 8) {
            Text(profile.description)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(Color(uiColor: .label))
                .lineLimit(4)
            
            if let site = profile.websiteURL {
                Link(site.absoluteString, destination: site)
                    .font(.system(size: 15, weight: .regular))
                    .tint(.blue)
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 20)
    }
}

struct ProfileListRow: View {
    let title: String
    let count: String?
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color(uiColor: .label))
            
            if let count = count {
                Text(count)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color(uiColor: .label))
            }
            
            Spacer()
        }
        .padding(.vertical, 16)
    }
}
