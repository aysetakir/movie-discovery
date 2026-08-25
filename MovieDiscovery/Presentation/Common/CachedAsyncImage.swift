import SwiftUI

struct CachedAsyncImage: View {
    let url: URL?
    
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Color.gray.opacity(0.3)
            }
        }
        .task(id: url) {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        guard let url else { return }
        
        if let cached = ImageCache.shared.image(for: url) {
            image = cached
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let downloaded = UIImage(data: data) else { return }
            ImageCache.shared.insert(image: downloaded, for: url)
            image = downloaded
        } catch {
            print("İndirme başarısız oldu")
        }
    }
}
