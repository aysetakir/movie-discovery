import Foundation

@MainActor
@Observable
final class MovieDetailViewModel {
    private(set) var movie: MovieDetail?
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private let movieId: Int
    
    private let repository: MovieRepository
    
    init(movieId: Int, repository: MovieRepository) {
        self.movieId = movieId
        self.repository = repository
    }
    
    func loadDetail() async {
        isLoading = true
        errorMessage = nil
        do {
            movie = try await repository.fetchMovieDetail(id: movieId)
            print("✅ Detay:", movie?.title ?? "nil", "| id:", movieId)
        } catch {
            errorMessage = "Detay yüklenemedi." 
        }
        isLoading = false
    }
}
