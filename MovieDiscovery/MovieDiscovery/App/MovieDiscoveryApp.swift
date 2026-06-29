import SwiftUI
import SwiftData

@main
struct MovieDiscoveryApp: App {
    var body: some Scene {
        WindowGroup {
            MovieListView(viewModel: MovieListViewModel(repository: MovieRepositoryImpl()))
        }
        .modelContainer(for: MovieEntity.self)
    }
}
 
