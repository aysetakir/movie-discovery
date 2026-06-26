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
    
    var searchText = ""
    private(set) var searchResults: [Movie] = []
    private(set) var isSearching = false
    
    private var searchTask: Task<Void, Never>?
    
    private let repository: MovieRepository
    var displayedMovies: [Movie] {
        searchText.trimmingCharacters(in: .whitespaces).isEmpty ? movies : searchResults
    }
    
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
    
    func searchTextChanged() {
        searchTask?.cancel()
        
        let query = searchText.trimmingCharacters(in: .whitespaces)
        
        guard !query.isEmpty else {
            searchResults = []
            isSearching = false
            return
        }
        
        searchTask = Task {
            do {
                try await Task.sleep(for:.milliseconds(500))
                isSearching = true
                let page = try await repository.searchMovies(query: query, page: 1)
                
                guard !Task.isCancelled else { return }
                searchResults = page.movies
                isSearching = false
            } catch {
                isSearching = false
            }
        }
        
    }
}
