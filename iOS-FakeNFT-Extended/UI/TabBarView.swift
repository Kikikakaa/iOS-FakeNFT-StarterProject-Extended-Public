import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            //Каталог
            NavigationStack {
                CatalogView()
            }
            .tabItem {
                Label(
                    NSLocalizedString("Tab.catalog", comment: ""),
                    systemImage: "square.stack.3d.up.fill"
                )
            }
            //Корзина
            NavigationStack {
                CartListView()
            }
            .tabItem {
                Label(
                    NSLocalizedString("Tab.cart", comment: ""),
                    systemImage: "basket"
                )
            }
            //Профиль
            NavigationStack {
                ProfileView()
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
