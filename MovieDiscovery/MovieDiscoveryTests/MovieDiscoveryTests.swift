import Foundation
@testable import MovieDiscovery

final class MockMovieRepository: MovieRepository {
    var moviesToReturn: [Movie] = []
    var shouldThrow = false

    func fetchPopularMovies(page: Int) async throws -> MoviePage {
        if shouldThrow {
            throw NetworkError.invalidResponse
        }
        return MoviePage(movies: moviesToReturn, page: 1, totalPages: 1)
    }

    func searchMovies(query: String, page: Int) async throws -> MoviePage {
        if shouldThrow {
            throw NetworkError.invalidResponse
        }
        return MoviePage(movies: moviesToReturn, page: 1, totalPages: 1)
    }

    func fetchMovieDetail(id: Int) async throws -> MovieDetail {
        fatalError("bu testte gerekli değil")
    }
}
