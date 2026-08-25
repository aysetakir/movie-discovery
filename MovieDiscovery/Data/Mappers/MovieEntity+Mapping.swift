import Foundation

extension MovieEntity {
    func toDomain() -> Movie {
        Movie(
            id: id,
            title: title,
            overview: overview,
            posterURL: posterURLString.flatMap { URL(string: $0) },
            backdropURL: backdropURLString.flatMap { URL(string: $0) },
            voteAverage: voteAverage,
            releaseDate: releaseDate,
            genreIds: []
        )
    }
}

extension Movie {
    func toEntity() -> MovieEntity {
        MovieEntity(
            id: id,
            title: title,
            overview: overview,
            posterURLString: posterURL?.absoluteString,
            backdropURLString: backdropURL?.absoluteString,
            voteAverage: voteAverage,
            releaseDate: releaseDate
        )
    }
}
