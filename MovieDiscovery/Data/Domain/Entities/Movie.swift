import Foundation

struct Movie: Identifiable, Equatable {
    let id: Int
    let title: String
    let overview: String
    let posterURL: URL?
    let backdropURL: URL?
    let voteAverage: Double
    let releaseDate: String?
    let genreIds: [Int]
}
