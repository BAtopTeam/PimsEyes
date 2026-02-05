import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedFilter: HistoryFilter = .search
    
    enum HistoryFilter: String, CaseIterable {
        case search = "Search"
        case cheater = "Cheater"
        case location = "Location"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                LinearGradient.pimHeaderGradient
                    .ignoresSafeArea(edges: .top)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("History")
                        .font(.pimTitle)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 12) {
                        ForEach(HistoryFilter.allCases, id: \.self) { filter in
                            FilterChip(
                                title: filter.rawValue,
                                isSelected: selectedFilter == filter
                            ) {
                                selectedFilter = filter
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .frame(height: 140)
            
            ScrollView {
                switch selectedFilter {
                case .search:
                    SearchHistoryGrid()
                case .cheater:
                    CheaterHistoryList()
                case .location:
                    LocationHistoryList()
                }
            }
            .background(Color.pimBackground)
        }
    }
}

struct SearchHistoryGrid: View {
    let items: [MockSearchItem] = [
        MockSearchItem(source: "tinder.com/@james..."),
        MockSearchItem(source: "tinder.com/@james..."),
        MockSearchItem(source: "tinder.com/@james..."),
        MockSearchItem(source: "tinder.com/@james..."),
        MockSearchItem(source: "tinder.com/@james..."),
        MockSearchItem(source: "tinder.com/@james...")
    ]
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ], spacing: 12) {
            ForEach(items) { item in
                HistorySearchCard(source: item.source)
            }
        }
        .padding(16)
    }
}

struct MockSearchItem: Identifiable {
    let id = UUID()
    let source: String
}

struct HistorySearchCard: View {
    let source: String
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 180)
                .cornerRadius(12)
            
            LinearGradient(
                colors: [.clear, .black.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(12)
            
            Circle()
                .fill(Color.pimAccent)
                .frame(width: 28, height: 28)
                .overlay(
                    Image(systemName: "flame.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                )
                .position(x: 24, y: 24)
            
            Text(source)
                .font(.pimSmall)
                .foregroundColor(.white)
                .padding(8)
        }
        .frame(height: 180)
    }
}

struct CheaterHistoryList: View {
    let items: [MockCheaterItem] = [
        MockCheaterItem(riskLevel: 80),
        MockCheaterItem(riskLevel: 80),
        MockCheaterItem(riskLevel: 80),
        MockCheaterItem(riskLevel: 80),
        MockCheaterItem(riskLevel: 80)
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(items) { item in
                CheaterHistoryRow(riskLevel: item.riskLevel)
            }
        }
        .padding(16)
    }
}

struct MockCheaterItem: Identifiable {
    let id = UUID()
    let riskLevel: Int
}

struct CheaterHistoryRow: View {
    let riskLevel: Int
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "doc.text.fill")
                        .foregroundColor(.pimPrimary)
                )
            
            Text("High risk level")
                .font(.pimBody)
                .foregroundColor(.pimTextPrimary)
            
            Spacer()
            
            Text("\(riskLevel)%")
                .font(.pimBody)
                .foregroundColor(.pimDanger)
        }
        .padding(12)
        .background(Color.pimCardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.pimBorder, lineWidth: 1)
        )
    }
}

struct LocationHistoryList: View {
    let items: [MockLocationItem] = [
        MockLocationItem(location: "Place de Stanislas, Nancy, France"),
        MockLocationItem(location: "Place de Stanislas, Nancy, France"),
        MockLocationItem(location: "Place de Stanislas, Nancy, France"),
        MockLocationItem(location: "Place de Stanislas, Nancy, France"),
        MockLocationItem(location: "Place de Stanislas, Nancy, France")
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(items) { item in
                LocationHistoryRow(location: item.location)
            }
        }
        .padding(16)
    }
}

struct MockLocationItem: Identifiable {
    let id = UUID()
    let location: String
}

struct LocationHistoryRow: View {
    let location: String
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 50, height: 50)
            
            Text(location)
                .font(.pimBody)
                .foregroundColor(.pimTextPrimary)
                .lineLimit(1)
            
            Spacer()
        }
        .padding(12)
        .background(Color.pimCardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.pimBorder, lineWidth: 1)
        )
    }
}

#Preview {
    HistoryView()
        .environmentObject(AppState())
}
