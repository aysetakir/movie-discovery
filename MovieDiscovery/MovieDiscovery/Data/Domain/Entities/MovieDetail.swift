import Foundation

struct MovieDetail: Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterURL: URL?
    let backdropURL: URL?
    let voteAverage: Double
    let releaseDate: String?
    let runtime: Int?
    let tagline: String?
    let genres: [String]
}
