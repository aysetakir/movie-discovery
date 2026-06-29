import SwiftUI

struct MovieListView: View {
    @State private var viewModel: MovieListViewModel

    init(viewModel: MovieListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.movies.isEmpty {
                    ProgressView("Yükleniyor")
                } else if let error = viewModel.errorMessage {
                    ErrorView(message: error) {
                        Task {
                            await viewModel.loadMovies()
                        }
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.displayedMovies) { movie in
                                NavigationLink(value: movie.id) {
                                    VStack(alignment: .leading, spacing: 6) {
                                        CachedAsyncImage(url: movie.posterURL)
                                            .aspectRatio(2/3, contentMode: .fill)
                                            .frame(maxWidth: .infinity)
                                            .clipped()
                                            .cornerRadius(8)

                                        Text(movie.title)
                                            .font(.caption)
                                            .lineLimit(2)
                                        Text(String(format: "★ %.1f", movie.voteAverage))
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .buttonStyle(.plain)
                                .onAppear {
                                    Task {
                                        await viewModel.loadMoreIfNeeded(currentItem: movie)
                                    }
                                }
                            }
                        }
                        .padding()

                        if viewModel.isLoadingMore {
                            ProgressView()
                                .padding()
                        }
                    }
                    .searchable(text: $viewModel.searchText)
                    .onChange(of: viewModel.searchText) {
                        viewModel.searchTextChanged()
                    }

                }
            }
            .navigationTitle("Filmler")
            .navigationDestination(for: Int.self) { movieId in
                MovieDetailView(
                    viewModel: MovieDetailViewModel(
                        movieId: movieId,
                        repository: MovieRepositoryImpl()
                    )
                )
            }
            .task {
                await viewModel.loadMovies()
            }
        }
    }
}

/*#Preview {
    MovieListView(viewModel: MovieListViewModel(repository: MovieRepositoryImpl()))
}*/
