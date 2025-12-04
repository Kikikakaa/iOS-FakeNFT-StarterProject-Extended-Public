import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
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
                TestCartListView()
            }
            .tabItem {
                Label(
                    NSLocalizedString("Tab.cart", comment: ""),
                    systemImage: "basket"
                )
            }
            NavigationStack {
                TestProfileView()
            }
            .tabItem {
                Label(
                    NSLocalizedString("Profile.title", comment: ""),
                    systemImage: "person.crop.circle.fill"
                )
            }
            .backgroundStyle(.background)
        }
    }
}
