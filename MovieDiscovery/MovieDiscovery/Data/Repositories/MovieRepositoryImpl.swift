
final class MovieRepositoryImpl: MovieRepository {
    
    func fetchPopularMovies(page: Int) async throws -> MoviePage {
        let endpoint = Endpoint.popularMovies(page: page)
        let dto: MoviePageDTO = try await APIClient.shared.request(endpoint: endpoint)
        return dto.toDomain()
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
