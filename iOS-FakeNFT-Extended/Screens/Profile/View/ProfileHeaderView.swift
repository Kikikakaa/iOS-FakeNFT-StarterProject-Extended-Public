import SwiftUI

struct ProfileHeaderView: View {
    let profile: ProfileModel
    let onWebsiteTap: (URL) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 16) {
                AsyncImage(url: profile.avatarURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 70, height: 70)
                    case .success(let image):
                        image.resizable().scaledToFill()
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
            }
            
            VStack(alignment: .leading, spacing: 8) {
                if !profile.description.isEmpty {
                    Text(profile.description)
                        .font(.system(size: 13, weight: .regular))
                        .kerning(-0.08) // Letter spacing -0.08 (как в Figma)
                        .foregroundStyle(Color(uiColor: .label))
                        .lineLimit(4)
                }
                
                if let site = profile.websiteURL {
                    Button {
                        onWebsiteTap(site)
                    } label: {
                        Text(site.absoluteString)
                            .font(.system(size: 15, weight: .regular))
                            .kerning(-0.24)
                            .tint(.blue)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 20)
    }
}
