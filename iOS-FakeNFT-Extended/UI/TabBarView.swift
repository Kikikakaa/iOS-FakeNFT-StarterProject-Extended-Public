import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            TestCatalogView()
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
    }
}
