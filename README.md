# Movie Discovery

A SwiftUI movie discovery app built on the TMDB API, focused on **iOS data-layer performance**: pagination, image caching, debounced search, task cancellation, and offline-first persistence.

This project was written deliberately — every performance decision is intentional, and the naive alternative is documented alongside the chosen approach.

## Tech Stack

- **SwiftUI** (iOS 17+) with `@Observable`
- **TMDB API** (v4 Bearer auth)
- **MVVM + Clean Architecture** — Domain / Data / Presentation layers
- **async/await** for all networking and persistence
- **SwiftData** for offline cache

## Architecture

The app follows **Clean Architecture** with a strict dependency rule: dependencies point inward, toward the Domain. The Domain layer is pure Swift with no framework imports.

```
App/                          Entry point + dependency injection
Core/
├── Config/                   Secure token access (AppConfig)
├── Network/                  Endpoint, NetworkError, APIClient
└── Cache/                    ImageCache (NSCache)
Domain/                       Pure Swift — no framework imports
├── Entities/                 Movie, MoviePage, MovieDetail
└── Repositories/             MovieRepository (protocol)
Data/
├── DTOs/                     TMDB JSON-shaped Codable structs
├── DataSources/Local/        SwiftData persistence (MovieEntity, LocalDataSource)
├── Mappers/                  DTO → Entity, Entity ↔ SwiftData model
└── Repositories/             MovieRepositoryImpl (API + cache)
Presentation/                 MVVM — Views + ViewModels
├── Common/                   Reusable views (CachedAsyncImage, ErrorView)
└── Movies/                   List + Detail screens
```

**Dependency inversion:** the `MovieRepository` protocol lives in Domain; its implementation lives in Data. ViewModels depend on the protocol, never the concrete type — so a mock repository can be injected for tests, and the data source (API vs cache) can change without touching the presentation layer.

**Three representations of a movie**, each owned by its layer: `MovieDTO` (API shape), `Movie` (domain entity), `MovieEntity` (`@Model`, persistence). Mappers translate between them, so an API change never leaks past the Data layer.

## Performance Highlights

Each of these solves a specific problem the naive approach gets wrong.

### Pagination (infinite scroll)
Loading all results at once is impossible (TMDB returns ~57k pages); a "load more" button is poor UX. Instead, the list prefetches the next page when the user reaches the last few cells (`onAppear` on grid items). A guard prevents duplicate in-flight requests, and a `currentPage < totalPages` check stops at the end. Because TMDB's popularity ranking shifts live, the same movie can appear on different pages — results are de-duplicated by `id` before appending.

### Image caching
`AsyncImage` relies indirectly on `URLSession`'s `URLCache`, which stores **raw data** and re-decodes the image on every display. As cells are recycled in a `LazyVGrid`, this causes visible flicker and wasted decode work. `CachedAsyncImage` caches the **decoded `UIImage`** in an `NSCache` (which evicts automatically under memory pressure), so a revisited poster appears instantly with no re-download or re-decode.

### Debounced search
Firing a request per keystroke wastes API quota and risks race conditions (an earlier response overwriting a later one). Search is debounced with `Task.sleep` + cancellation: each keystroke cancels the previous task, and the request only fires after the user pauses — turning "batman" from 6 requests into 1. `Task.isCancelled` guards against stale results.

### Task cancellation
`CachedAsyncImage` uses `.task(id:)`, so when a cell scrolls off-screen its in-flight image download is cancelled automatically. The same cancellation primitive powers the debounced search.

### Main-thread safety
ViewModels are annotated `@MainActor`. State that drives the UI is updated on the main thread; this matters because the thread on which code resumes after an `await` is not guaranteed.

### Offline-first cache (SwiftData)
The first page of popular movies is persisted with SwiftData. The repository tries the API first; on failure (e.g. no connection) it falls back to the cache, so the app shows the last-seen movies instead of an empty screen. Cache injection is optional — only the list repository receives it, since detail data isn't cached.

## Setup

1. Get a TMDB **API Read Access Token (v4)** from [themoviedb.org/settings/api](https://www.themoviedb.org/settings/api).
2. Create a `Secrets.xcconfig` file in the project root (it is git-ignored):
   ```
   TMDB_ACCESS_TOKEN = your_token_here
   ```
3. The token flows `Secrets.xcconfig → Info.plist → AppConfig`, keeping the secret out of source control. The token is read at runtime via `AppConfig.tmdbAccessToken`.
4. Open in Xcode (iOS 17+) and run.

> **Note on secrets:** the xcconfig approach keeps the token out of git history. In production the token would be proxied through a backend rather than shipped in the app bundle, since a client-side token can still be extracted from the binary.

## Possible Improvements

- Disk-based image cache (current cache is memory-only)
- A DI container instead of manual injection at the composition root
- Incremental/upsert cache writes instead of full-replace
- Unit tests with a mock `MovieRepository`
- Pagination for search results
