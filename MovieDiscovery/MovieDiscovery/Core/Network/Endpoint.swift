import Foundation

enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let queryItems: [URLQueryItem]
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3" + path
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        return components.url
    }
}

extension Endpoint {
    static func popularMovies(page: Int) -> Endpoint {
        Endpoint(
            path: "/movie/popular",
            method: .get,
            queryItems: [URLQueryItem(name: "page", value: "\(page)")]
        )
    }
}
