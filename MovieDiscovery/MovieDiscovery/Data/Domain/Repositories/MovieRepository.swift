protocol MovieRepository {
    func fetchPopularMovies(page: Int) async throws ->  MoviePage
    func searchMovies(query: String, page: Int) async throws -> MoviePage
}
 
