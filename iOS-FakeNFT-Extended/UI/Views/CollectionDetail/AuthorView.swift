//
//  AuthorView.swift
//  iOS-FakeNFT-Extended

import SwiftUI

struct AuthorView: View {
    let author: Author
    
    @State private var showSafari = false
    
    var body: some View {
        Button(action: {
            showSafari = true
        }) {
            HStack {
                Text("Автор: \(author.name)")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                Image(systemName: "link")
                    .font(.system(size: 12))
                    .foregroundColor(.blue)
            }
        }
        .sheet(isPresented: $showSafari) {
            SafariView(url: author.website)
        }
    }
}

struct AuthorView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorView(author: Author(
            name: "Иван Петров",
            website: URL(string: "https://example.com")!
        ))
    }
}
