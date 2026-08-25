import Testing
@testable import MovieDiscovery

@MainActor
struct MovieListViewModelTests {

    @Test func loadMovies_success_populatesMovies() async {
        let mock = MockMovieRepository()
        mock.moviesToReturn = [
            Movie(id: 1, title: "Test Film", overview: "", posterURL: nil,
                  backdropURL: nil, voteAverage: 8.0, releaseDate: nil, genreIds: [])
        ]
        let sut = MovieListViewModel(repository: mock)

        await sut.loadMovies()

        #expect(sut.movies.count == 1)
        #expect(sut.movies.first?.title == "Test Film")
        #expect(sut.errorMessage == nil)
    }

    @Test func loadMovies_failure_setsError() async {
        let mock = MockMovieRepository()
        mock.shouldThrow = true
        let sut = MovieListViewModel(repository: mock)

        await sut.loadMovies()

        #expect(sut.movies.isEmpty)
        #expect(sut.errorMessage != nil)
    }
}
