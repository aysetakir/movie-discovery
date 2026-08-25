import Foundation

extension MovieDTO {
    private static let imageBaseURL = "https://image.tmdb.org/t/p/w500"

    func toDomain() -> Movie {
        Movie(
            id: id,
            title: title,
            overview: overview,
            posterURL: posterPath.flatMap { URL(string: Self.imageBaseURL + $0) },
            backdropURL: backdropPath.flatMap { URL(string: Self.imageBaseURL + $0) },
            voteAverage: voteAverage,
            releaseDate: releaseDate,
            genreIds: genreIds
        )
    }
}

extension MoviePageDTO {
    func toDomain() -> MoviePage {
        MoviePage(
            movies: results.map { $0.toDomain() }, 
            page: page,
            totalPages: totalPages
        )
    }
}
