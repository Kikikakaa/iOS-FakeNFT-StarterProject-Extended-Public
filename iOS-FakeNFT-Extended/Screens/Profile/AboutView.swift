import SwiftUI

struct AboutView: View {
    let url: URL
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        WebView(url: url)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("Backward")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color(uiColor: .label))
                    }
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .toolbar(.hidden, for: .tabBar)
    }
}
