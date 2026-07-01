# Movie Discovery

A SwiftUI movie discovery app on the TMDB API, focused on **iOS data-layer performance**: pagination, image caching, debounced search, task cancellation, and offline-first persistence. Every performance decision is intentional, with the naive alternative documented alongside the chosen approach.

## Tech Stack

- **SwiftUI** (iOS 17+), `@Observable`
- **TMDB API** (v4 Bearer auth), **async/await**
- **MVVM + Clean Architecture** — Domain / Data / Presentation
- **SwiftData** for offline cache
- **Unit tests** (Swift Testing) with dependency-injected mocks

## Architecture

Clean Architecture with a strict inward dependency rule. The Domain layer is pure Swift — no framework imports.

```
Core/        Config (secure token), Network (Endpoint/APIClient/NetworkError), Cache (ImageCache)
Domain/      Entities (Movie, MoviePage, MovieDetail), MovieRepository (protocol)
Data/        DTOs, SwiftData persistence, Mappers, MovieRepositoryImpl (API + cache)
Presentation/ Views + ViewModels (MVVM)
```

**Dependency inversion:** the `MovieRepository` protocol lives in Domain, its implementation in Data. ViewModels depend on the protocol, never the concrete type — so mocks can be injected for tests and the data source (API vs cache) can change without touching the UI.

**Three representations of a movie**, one per layer: `MovieDTO` (API shape) → `Movie` (domain entity) → `MovieEntity` (`@Model`, persistence). Mappers translate between them, so API changes never leak past the Data layer.

## Technical Highlights

**Pagination (infinite scroll).** The list prefetches the next page when the user reaches the last few cells (`onAppear` on grid items). An in-flight guard prevents duplicate requests and a `currentPage < totalPages` check stops at the end. Since TMDB's popularity ranking shifts live, the same movie can appear on multiple pages — results are de-duplicated by `id` before appending.

**Image caching.** `AsyncImage` relies on `URLSession`'s `URLCache`, which stores raw data and re-decodes on every display — causing flicker as `LazyVGrid` cells recycle. `CachedAsyncImage` caches the decoded `UIImage` in an `NSCache` (auto-evicting under memory pressure), so a revisited poster appears instantly.

**Debounced search.** Per-keystroke requests waste quota and risk race conditions. Search is debounced with `Task.sleep` + cancellation: each keystroke cancels the previous task, so the request fires only after the user pauses ("batman" → 1 request instead of 6). `Task.isCancelled` guards against stale results.

**Task cancellation.** `CachedAsyncImage` uses `.task(id:)`, cancelling an in-flight image download when a cell scrolls off-screen. The same primitive powers debounced search.

**Main-thread safety.** ViewModels are `@MainActor`, since the thread on which code resumes after `await` is not guaranteed.

**Offline-first cache (SwiftData).** The first page is persisted; the repository tries the API first and falls back to cache on failure, showing last-seen movies instead of an empty screen. Cache injection is optional — only the list repository receives it.

**Testing.** ViewModel logic (success/error state) and mappers (URL building, optional handling) are unit-tested with a mock `MovieRepository`, made possible by the protocol-based dependency injection.

## Setup

1. Get a TMDB **API Read Access Token (v4)** from [themoviedb.org/settings/api](https://www.themoviedb.org/settings/api).
2. Create a git-ignored `Secrets.xcconfig` in the project root:
   ```
   TMDB_ACCESS_TOKEN = your_token_here
   ```
3. The token flows `Secrets.xcconfig → Info.plist → AppConfig`, read at runtime via `AppConfig.tmdbAccessToken` — keeping it out of source control.
4. Open in Xcode (iOS 17+) and run.

> In production the token would be proxied through a backend rather than shipped in the bundle, since a client-side token can still be extracted from the binary.

## Possible Improvements

- Disk-based image cache (currently memory-only)
- A DI container instead of manual injection at the composition root
- Incremental/upsert cache writes instead of full-replace
- Pagination for search results
