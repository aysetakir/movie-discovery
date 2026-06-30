@MainActor
final class MovieRepositoryImpl: MovieRepository {
    private let local: MovieLocalDataSource?

    init(local: MovieLocalDataSource? = nil) {
        self.local = local
    }

    func fetchPopularMovies(page: Int) async throws -> MoviePage {
        do {
            let endpoint = Endpoint.popularMovies(page: page)
            let dto: MoviePageDTO = try await APIClient.shared.request(endpoint: endpoint)
            let moviePage = dto.toDomain()

            if page == 1 {
                try?  local?.saveMovies(moviePage.movies)
            }

            return moviePage
        } catch {
            guard let cached = try? local?.fetchMovies(), !cached.isEmpty else {
                throw error
            }
            return MoviePage(movies: cached, page: 1, totalPages: 1)
        }
    }

    func searchMovies(query: String, page: Int) async throws -> MoviePage {
        let endpoint = Endpoint.searchMovies(query: query, page: page)
        let dto: MoviePageDTO = try await APIClient.shared.request(endpoint: endpoint)
        return dto.toDomain()
    }

    func fetchMovieDetail(id: Int) async throws -> MovieDetail {
        let endpoint = Endpoint.movieDetail(id: id)
        let dto: MovieDetailDTO = try await APIClient.shared.request(endpoint: endpoint)
        return dto.toDomain()
    }
}
