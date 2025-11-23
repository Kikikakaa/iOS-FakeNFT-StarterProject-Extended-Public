//
//  CatalogView.swift
//  iOS-FakeNFT-Extended

import SwiftUI

struct CatalogView: View {
    
    @StateObject private var viewModel: CatalogViewModel
    @State private var showingSortOptions = false
    @State private var path = NavigationPath()

    @MainActor
    init() {
        _viewModel = StateObject(wrappedValue: CatalogViewModel())
    }

    // Инициализатор для инъекции (например, в превью или тестах)
    @MainActor
    init(viewModel: CatalogViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else {
                    List(viewModel.sortedCollections) { catalogCollectionItem in
                        Button {
                            path.append(catalogCollectionItem)
                        } label: {
                            CollectionRow(catalogCollectionItem: catalogCollectionItem)
                        }
                        .buttonStyle(.plain)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await viewModel.loadCollections()
                    }
                }
            }
            .navigationDestination(for: CatalogCollectionItem.self) { catalogCollectionItem in
                CollectionDetailView(catalogCollectionItem: catalogCollectionItem)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSortOptions = true
                    } label: {
                        Image(.sortButton)
                    }
                }
            }
            .confirmationDialog("Сортировка", isPresented: $showingSortOptions) {
                Button("По названию") { viewModel.sortOption = CatalogViewModel.SortOption.byName }
                Button("По количеству NFT") { viewModel.sortOption = CatalogViewModel.SortOption.byCount }
                Button("Отмена", role: .cancel) { }
            } message: {
                Text("Сортировка")
            }
            .task {
                await viewModel.loadCollections()
            }
        }
    }
}

struct CollectionDetailStubView: View {
    let catalogCollectionItem: CatalogCollectionItem

    var body: some View {
        VStack {
            Text(catalogCollectionItem.name)
                .font(.title)
            Text("Здесь будет экран коллекции NFT")
                .foregroundColor(.secondary)
            Text("Количество NFT: \(catalogCollectionItem.nftsCount)")
        }
        .padding()
    }
}

@MainActor
struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
        let mockVM = CatalogViewModel(catalogService: MockCatalogService())
        mockVM.collections = MockCatalogData.catalogCollections
        mockVM.isLoading = false

        return CatalogView(viewModel: mockVM)
    }
}

