import Foundation
import SwiftData

@MainActor
final class MovieLocalDataSource {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetchMovies() throws -> [Movie] {
        let descriptor = FetchDescriptor<MovieEntity>(
            sortBy: [SortDescriptor(\.voteAverage, order: .reverse)]
        )
        let entities = try context.fetch(descriptor)
        return entities.map { $0.toDomain()}
    }
    
    
    func saveMovies(_ movies: [Movie]) throws {
        try context.delete(model: MovieEntity.self)
        for movie in movies {
            context.insert(movie.toEntity())
        }
        try context.save()
    }
}
