import SwiftUI

struct HomeView: View {
    @State private var showSearchByPhoto = false
    @State private var showAnalyzeMessages = false
    @State private var showLocatePlace = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ZStack {
                    LinearGradient.pimHeaderGradient
                        .ignoresSafeArea(edges: .top)
                    
                    Text("PimEyes")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .italic()
                        .foregroundColor(.white)
                }
                .frame(height: 56)
                
                ScrollView {
                    VStack(spacing: 16) {
                        FeatureCard(
                            icon: "person.2.crop.square.stack",
                            title: "Find profiles by face",
                            description: "Find out if this person is really who they say they are.",
                            buttonTitle: "Search by photo",
                            action: { showSearchByPhoto = true }
                        )
                        
                        FeatureCard(
                            icon: "exclamationmark.triangle",
                            title: "Detect scam in messages",
                            description: "AI uncovers hidden red flags, manipulation, or risky behavior.",
                            buttonTitle: "Analyze messages",
                            action: { showAnalyzeMessages = true }
                        )
                        
                        FeatureCard(
                            icon: "location.circle",
                            title: "Find out the location from a photo",
                            description: "AI analyzes surroundings and architecture to pinpoint the location.",
                            buttonTitle: "Find a place",
                            action: { showLocatePlace = true }
                        )
                    }
                    .padding(16)
                }
                .background(Color.pimBackground)
            }
            .navigationDestination(isPresented: $showSearchByPhoto) {
                SearchByPhotoView()
            }
            .navigationDestination(isPresented: $showAnalyzeMessages) {
                AnalyzeMessagesView()
            }
            .navigationDestination(isPresented: $showLocatePlace) {
                LocatePlaceView()
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}
