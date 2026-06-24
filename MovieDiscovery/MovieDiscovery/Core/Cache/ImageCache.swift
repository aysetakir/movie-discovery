import UIKit

final class ImageCache {
    static let shared =  ImageCache()
    private init() {}
    
    private let cache = NSCache<NSURL, UIImage>()
    
    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }
    
    func insert(image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}
