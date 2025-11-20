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
                    List(viewModel.sortedCollections) { collection in
                        Button {
                            path.append(collection)
                        } label: {
                            CollectionRow(collection: collection)
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
            .navigationTitle("Каталог")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSortOptions = true
                    } label: {
                        Image("sort_button")
                    }
                }
            }
            .confirmationDialog("Сортировка", isPresented: $showingSortOptions) {
                Button("По названию") { viewModel.sortOption = CatalogViewModel.SortOption.byName }
                Button("По количеству NFT") { viewModel.sortOption = CatalogViewModel.SortOption.byCount }
                Button("Отмена", role: .cancel) { }
            } message: {
                Text("Выберите способ сортировки коллекций")
            }
            .task {
                await viewModel.loadCollections()
            }
        }
    }
}

struct CollectionDetailStubView: View {
    let collection: Collection

    var body: some View {
        VStack {
            Text(collection.name)
                .font(.title)
            Text("Здесь будет экран коллекции NFT")
                .foregroundColor(.secondary)
            Text("Количество NFT: \(collection.nftsCount)")
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

