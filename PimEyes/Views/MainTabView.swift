import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home, history, settings
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .history:
                    HistoryView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack {
                Spacer()
                
                Button(action: { selectedTab = .home }) {
                    TabItem(icon: "house.fill", title: "Home", isSelected: selectedTab == .home)
                }
                
                Spacer()
                
                Button(action: { selectedTab = .history }) {
                    TabItem(icon: "clock", title: "History", isSelected: selectedTab == .history)
                }
                
                Spacer()
                
                Button(action: { selectedTab = .settings }) {
                    TabItem(icon: "gearshape", title: "Settings", isSelected: selectedTab == .settings)
                }
                
                Spacer()
            }
            .padding(.vertical, 12)
            .background(Color.pimCardBackground)
            .overlay(
                Rectangle()
                    .fill(Color.pimBorder)
                    .frame(height: 1),
                alignment: .top
            )
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
}
