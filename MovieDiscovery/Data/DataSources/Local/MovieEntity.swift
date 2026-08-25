import Foundation
import SwiftData

@Model
final class MovieEntity {
    @Attribute(.unique) var id: Int
    var title: String
    var overview: String
    var posterURLString: String?
    var backdropURLString: String?
    var voteAverage: Double
    var releaseDate: String?

    init(
        id: Int,
        title: String,
        overview: String,
        posterURLString: String?,
        backdropURLString: String?,
        voteAverage: Double,
        releaseDate: String?
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterURLString = posterURLString
        self.backdropURLString = backdropURLString
        self.voteAverage = voteAverage
        self.releaseDate = releaseDate
    }
}
