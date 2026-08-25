import SwiftUI
import SwiftData

@main
struct MovieDiscoveryApp: App {
    let container: ModelContainer
    init() {
        do {
            container = try ModelContainer(for: MovieEntity.self)
        } catch {
            fatalError("Modelcontainer kurulamadi: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MovieListView(
                viewModel: MovieListViewModel(
                    repository: MovieRepositoryImpl(
                        local: MovieLocalDataSource(
                            context: container.mainContext
                        )
                    )
                )
            )
        }
        .modelContainer(container)
    }
}

