import Testing
@testable import MovieDiscovery
import Foundation

struct MovieMapperTests {

    @Test func toDomain_withPosterPath_buildsFullURL() {
        let dto = MovieDTO(
            id: 1,
            title: "Test",
            overview: "",
            posterPath: "/abc.jpg",
            backdropPath: nil,
            voteAverage: 8.0,
            releaseDate: nil,
            genreIds: []
        )

        let movie = dto.toDomain()

        #expect(movie.posterURL?.absoluteString == "https://image.tmdb.org/t/p/w500/abc.jpg")
    }

    @Test func toDomain_withNilPoster_staysNil() {
        let dto = MovieDTO(
            id: 1,
            title: "Test",
            overview: "",
            posterPath: nil,
            backdropPath: nil,
            voteAverage: 8.0,
            releaseDate: nil,
            genreIds: []
        )

        let movie = dto.toDomain()

        #expect(movie.posterURL == nil)
    }

    @Test func toDomain_copiesBasicFields() {
        let dto = MovieDTO(
            id: 42,
            title: "Fight Club",
            overview: "bir özet",
            posterPath: nil,
            backdropPath: nil,
            voteAverage: 8.4,
            releaseDate: "1999-10-15",
            genreIds: [18, 53]
        )

        let movie = dto.toDomain()

        #expect(movie.id == 42)
        #expect(movie.title == "Fight Club")
        #expect(movie.voteAverage == 8.4)
        #expect(movie.genreIds == [18, 53])
    }
}
