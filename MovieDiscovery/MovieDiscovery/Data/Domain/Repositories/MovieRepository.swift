protocol MovieRepository {
    func fetchPopularMovies(page: Int) async throws ->  MoviePage
}
