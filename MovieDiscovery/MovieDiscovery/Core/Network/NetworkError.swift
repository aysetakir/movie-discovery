import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case invalidStatusCode(Int)
    case decodingFailed(Error)
}

