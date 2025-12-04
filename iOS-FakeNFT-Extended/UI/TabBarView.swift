import SwiftUI

struct TabBarView: View {
    @Environment(ServicesAssembly.self) private var servicesAssembly
    
    var body: some View {
        TabView {
            ProfileView()
                .tabItem {
                    Label(
                        NSLocalizedString("Profile.title", comment: ""),
                        systemImage: "person.crop.circle.fill"
                    )
                }
                .backgroundStyle(.background)

            NavigationStack {
                CatalogView()
            }
            .tabItem {
                Label(
                    NSLocalizedString("Tab.catalog", comment: ""),
                    systemImage: "square.stack.3d.up.fill"
                )
            }
            
            NavigationStack {
                CartListView()
            }
            .tabItem {
                Label(
                    NSLocalizedString("Tab.cart", comment: ""),
                    systemImage: "basket"
                )
            }
            .backgroundStyle(.background)
        }
        .tint(.blue)
    }
}
