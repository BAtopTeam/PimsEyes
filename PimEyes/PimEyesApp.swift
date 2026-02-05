import SwiftUI
internal import Combine

@main
struct PimEyesApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

class AppState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    @Published var isPremium: Bool = false
    @Published var searchHistory: [SearchHistoryItem] = []
    @Published var cheaterHistory: [CheaterHistoryItem] = []
    @Published var locationHistory: [LocationHistoryItem] = []
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
}

struct SearchHistoryItem: Identifiable {
    let id = UUID()
    let image: String
    let name: String
    let source: String
    let date: Date
}

struct CheaterHistoryItem: Identifiable {
    let id = UUID()
    let image: String
    let riskLevel: Int
    let date: Date
}

struct LocationHistoryItem: Identifiable {
    let id = UUID()
    let image: String
    let location: String
    let date: Date
}
