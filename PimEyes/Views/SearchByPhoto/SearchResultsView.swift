import SwiftUI

struct SearchResultsView: View {
    @Environment(\.dismiss) var dismiss
    let image: UIImage
    let gender: GenderSelector.Gender
    
    let results: [SearchResult] = [
        SearchResult(name: "Liam Bone", source: "tinder.com/@james..."),
        SearchResult(name: "Liam Bone", source: "tinder.com/@james..."),
        SearchResult(name: "Liam Bone", source: "tinder.com/@james..."),
        SearchResult(name: "Liam Bone", source: "tinder.com/@james..."),
        SearchResult(name: "Liam Bone", source: "tinder.com/@james..."),
        SearchResult(name: "Liam Bone", source: "tinder.com/@james...")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Analysis results", onBack: { dismiss() })
            
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 12) {
                    ForEach(results) { result in
                        ResultCard(image: image, name: result.name, source: result.source)
                    }
                }
                .padding(16)
            }
            .background(Color.pimBackground)
        }
        .navigationBarHidden(true)
    }
}

struct SearchResult: Identifiable {
    let id = UUID()
    let name: String
    let source: String
}

struct ResultCard: View {
    let image: UIImage
    let name: String
    let source: String
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .clipped()
                .cornerRadius(12)
            
            LinearGradient(
                colors: [.clear, .black.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(12)
            
            HStack {
                Image("tinder-icon")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .background(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 24, height: 24)
                    )
            }
            .position(x: 20, y: 20)
            
            Text(name)
                .font(.pimCaption)
                .foregroundColor(.white)
                .padding(8)
        }
        .frame(height: 180)
    }
}

#Preview {
    SearchResultsView(image: UIImage(systemName: "person.fill")!, gender: .man)
        .environmentObject(AppState())
}
