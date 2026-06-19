import Foundation

struct MoviePageDTO: Decodable {
    let page: Int
    let results: [MovieDTO]
    let totalPages: Int
    let totalResults: Int
}
