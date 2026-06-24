import Foundation

@MainActor
@Observable
final class MovieListViewModel {
    private(set) var movies: [Movie] = []
    private(set) var errorMessage: String?
    private(set) var currentPage = 0
    private(set) var totalPage = 1
    private(set) var isLoading = false
    private(set) var isLoadingMore = false
    
    private let repository: MovieRepository
    
    init(repository: MovieRepository) {
        self.repository = repository
    }
    
    func loadMovies() async {
        isLoading = true
        errorMessage = nil
        do {
            let page = try await repository.fetchPopularMovies(page: 1)
            movies = page.movies
        } catch {
            errorMessage = "Filmler yüklenemedi."
        }
        isLoading = false
    }
    
    func loadMoreIfNeeded(currentItem movie: Movie) async {
        guard shouldLoadMore(currentItem: movie) else { return }
        guard !isLoadingMore, currentPage < totalPage else { return }
        
        isLoadingMore = true
        
        do {
            let nextPage = currentPage + 1
            let page = try await repository.fetchPopularMovies(page: nextPage)
            let existingIDs = Set(movies.map { $0.id })
            let newMovies = page.movies.filter { !existingIDs.contains($0.id) }
            movies += newMovies
            currentPage = page.page
            totalPage = page.totalPages
        } catch {
            
        }
        isLoadingMore = false
    }
    
    
    func shouldLoadMore(currentItem movie: Movie) -> Bool {
        guard let index = movies.firstIndex(where: {$0.id == movie.id}) else {
            return false
        }
        let threshold = movies.count - 5
        return index >= threshold
    }
}
