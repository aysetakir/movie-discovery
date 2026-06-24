import SwiftUI

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        ContentUnavailableView {
            Label("Bir şeyler ters gitti", systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button("Tekrar Dene", action: retryAction)
                .buttonStyle(.bordered)
                .foregroundStyle(.black.opacity(0.7))
        }
    }
}

#Preview {
    ErrorView(message: "Filmler yüklenemedi.") {
        print("d")
    }
}
