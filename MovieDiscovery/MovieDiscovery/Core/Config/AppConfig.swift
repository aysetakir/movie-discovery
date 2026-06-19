import Foundation

enum AppConfig {
    static let tmdbAccessToken: String = {
        guard
            let token = Bundle.main.object(forInfoDictionaryKey: "TMDB_ACCESS_TOKEN") as? String,
            !token.isEmpty
        else {
            fatalError("hata")
        }
        return token
    }()
}
