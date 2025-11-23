import SwiftUI

struct ProfileHeaderView: View {
    let profile: ProfileModel
    
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
