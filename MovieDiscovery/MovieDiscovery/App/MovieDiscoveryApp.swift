import SwiftUI

@main
struct MovieDiscoveryApp: App {
    var body: some Scene {
        WindowGroup {
            MovieListView(viewModel: MovieListViewModel(repository: MovieRepositoryImpl()))
        }
    }
}
 
