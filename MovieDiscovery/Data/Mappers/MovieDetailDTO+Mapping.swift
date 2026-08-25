import Foundation

extension MovieDetailDTO {
    private static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    
    func toDomain() -> MovieDetail {
        MovieDetail(
            id: id,
            title: title,
            overview: overview,
            posterURL: posterPath.flatMap { URL(string: Self.imageBaseURL + $0) },
            backdropURL: backdropPath.flatMap { URL(string: Self.imageBaseURL + $0) },
            voteAverage: voteAverage,
            releaseDate: releaseDate,
            runtime: runtime,
            tagline: tagline,
            genres: genres.map { $0.name }
        )
    }
}
