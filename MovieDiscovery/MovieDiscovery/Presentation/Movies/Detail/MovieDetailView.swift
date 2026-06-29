import SwiftUI

struct MovieDetailView: View {
    @State private var viewModel: MovieDetailViewModel

    init(viewModel: MovieDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                ErrorView(message: error) {
                    Task { await viewModel.loadDetail() }
                }
            } else if let movie = viewModel.movie {
                content(movie)
            }
        }
        .task {
            await viewModel.loadDetail()
        }
    }

    private func content(_ movie: MovieDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CachedAsyncImage(url: movie.backdropURL)
                    .aspectRatio(16/9, contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .clipped()

                VStack(alignment: .leading, spacing: 12) {
                    Text(movie.title)
                        .font(.title)
                        .bold()

                    if let tagline = movie.tagline, !tagline.isEmpty {
                        Text(tagline)
                            .font(.subheadline)
                            .italic()
                            .foregroundStyle(.secondary)
                    }

                    HStack(spacing: 16) {
                        Label(String(format: "%.1f", movie.voteAverage), systemImage: "star.fill")
                        if let runtime = movie.runtime {
                            Label("\(runtime) dk", systemImage: "clock")
                        }
                        if let date = movie.releaseDate {
                            Text(date.prefix(4))
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                    if !movie.genres.isEmpty {
                        Text(movie.genres.joined(separator: ", "))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Text(movie.overview)
                        .font(.body)
                        .padding(.top, 8)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
    }
}

/*#Preview {
    NavigationStack {
        MovieDetailView(
            viewModel: MovieDetailViewModel(
                movieId: 550,
                repository: MovieRepositoryImpl()
            )
        )
    }
}*/
