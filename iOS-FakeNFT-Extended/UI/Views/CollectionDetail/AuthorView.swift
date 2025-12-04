//
//  AuthorView.swift
//  iOS-FakeNFT-Extended
//  Сделал изменение для отражение ветки на Git

import SwiftUI

struct AuthorView: View {
    let author: Author
    @State private var showSafari = false

    var body: some View {
        Button(action: {
            showSafari = true
        }) {
            HStack {
                Text("Автор коллекции:")
                    .font(
                        .system(
                            size: AppConstants.AuthorView.labelFontSize,
                            weight: .medium
                        )
                    )
                    .foregroundColor(.black)

                Text(author.name)
                    .font(
                        .system(
                            size: AppConstants.AuthorView.nameFontSize,
                            weight: .regular
                        )
                    )
                    .foregroundColor(AppConstants.Colors.blueUniversal)
            }
        }
        .sheet(isPresented: $showSafari) {
            SafariView(url: author.website)
        }
    }
}

struct AuthorView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorView(
            author: Author(
                name: "Иван Петров",
                website: URL(string: "https://example.com")!
            )
        )
    }
}
