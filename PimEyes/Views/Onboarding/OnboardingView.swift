import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentPage = 0
    @State private var showPaywall = false
    
    let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "eye.circle.fill",
            title: "",
            description: "",
            isLogoPage: true
        ),
        OnboardingPage(
            icon: "person.fill.viewfinder",
            title: "Find out who he really is",
            highlightedText: "who he really is",
            description: "AI scans the internet and shows every place his photos appear.",
            isLogoPage: false
        ),
        OnboardingPage(
            icon: "exclamationmark.triangle.fill",
            title: "Find Red Flags",
            highlightedText: "Red Flags",
            description: "AI highlights red flags, lies, pressure and hidden intentions.",
            isLogoPage: false
        ),
        OnboardingPage(
            icon: "person.3.fill",
            title: "See all his hidden profiles",
            highlightedText: "hidden profiles",
            description: "AI finds every photo match and shows where else he appears.",
            isLogoPage: false
        )
    ]
    
    var body: some View {
        ZStack {
            Color.pimBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.pimPrimary : Color.pimBorder)
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 24)
                
                PrimaryButton(title: "Continue") {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        showPaywall = true
                    }
                }
                .padding(.horizontal, 24)
                
                HStack(spacing: 16) {
                    Button("Privacy Policy") {}
                        .font(.pimSmall)
                        .foregroundColor(.pimTextSecondary)
                    
                    Text("|")
                        .foregroundColor(.pimTextSecondary)
                    
                    Button("Restore") {}
                        .font(.pimSmall)
                        .foregroundColor(.pimTextSecondary)
                    
                    Text("|")
                        .foregroundColor(.pimTextSecondary)
                    
                    Button("Terms of Use") {}
                        .font(.pimSmall)
                        .foregroundColor(.pimTextSecondary)
                }
                .padding(.vertical, 16)
            }
        }
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView()
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    var highlightedText: String = ""
    let description: String
    let isLogoPage: Bool
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            if page.isLogoPage {
                Image(systemName: "eye.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.pimPrimary)
            } else {
                ZStack {
                    Circle()
                        .fill(Color.pimPrimary.opacity(0.1))
                        .frame(width: 200, height: 200)
                    
                    Image(systemName: page.icon)
                        .font(.system(size: 60))
                        .foregroundColor(.pimPrimary)
                }
                
                if !page.highlightedText.isEmpty {
                    let parts = page.title.components(separatedBy: page.highlightedText)
                    HStack(spacing: 0) {
                        if parts.count > 0 {
                            Text(parts[0])
                                .foregroundColor(.pimTextPrimary)
                        }
                        Text(page.highlightedText)
                            .foregroundColor(.pimAccent)
                        if parts.count > 1 {
                            Text(parts[1])
                                .foregroundColor(.pimTextPrimary)
                        }
                    }
                    .font(.pimTitle)
                    .multilineTextAlignment(.center)
                } else {
                    Text(page.title)
                        .font(.pimTitle)
                        .foregroundColor(.pimTextPrimary)
                        .multilineTextAlignment(.center)
                }
                
                Text(page.description)
                    .font(.pimBody)
                    .foregroundColor(.pimTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
}
