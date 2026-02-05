import SwiftUI

struct SettingsView: View {
    @State private var showPaywall = false
    @State private var showPasscode = false
    @State private var showSecurityOptions = false
    @State private var showRateUs = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ZStack(alignment: .bottomLeading) {
                    LinearGradient.pimHeaderGradient
                        .ignoresSafeArea(edges: .top)
                    
                    Text("Settings")
                        .font(.pimTitle)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                }
                .frame(height: 100)
                
                ScrollView {
                    VStack(spacing: 16) {
                        SettingsSection {
                            SettingsRow(icon: "sparkles", title: "Get a premium") {
                                showPaywall = true
                            }
                            Divider().padding(.leading, 52)
                            SettingsRow(icon: "arrow.clockwise", title: "Restore purchases") {
                            }
                        }
                        
                        SettingsSection {
                            SettingsRow(icon: "headphones", title: "Support") {
                            }
                            Divider().padding(.leading, 52)
                            SettingsRow(icon: "doc.text", title: "Terms of Use") {
                            }
                            Divider().padding(.leading, 52)
                            SettingsRow(icon: "shield", title: "Privacy Policy") {
                            }
                        }
                        
                        SettingsSection {
                            SettingsRow(icon: "star", title: "Rate Us") {
                                showRateUs = true
                            }
                            Divider().padding(.leading, 52)
                            SettingsRow(icon: "square.and.arrow.up", title: "Share with friends") {
                            }
                        }
                        
                        SettingsSection {
                            SettingsRow(icon: "faceid", title: "Face ID & Passcode") {
                                showSecurityOptions = true
                            }
                        }
                    }
                    .padding(16)
                }
                .background(Color.pimBackground)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showSecurityOptions) {
                SecurityOptionsSheet(
                    onSelectFaceID: {
                        showSecurityOptions = false
                    },
                    onSelectPasscode: {
                        showSecurityOptions = false
                        showPasscode = true
                    }
                )
                .presentationDetents([.height(180)])
            }
            .fullScreenCover(isPresented: $showPasscode) {
                PasscodeView()
            }
            .fullScreenCover(isPresented: $showRateUs) {
                RateUsView()
            }
        }
    }
}

struct SettingsSection<Content: View>: View {
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(Color.pimCardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.pimBorder, lineWidth: 1)
        )
    }
}

struct SecurityOptionsSheet: View {
    let onSelectFaceID: () -> Void
    let onSelectPasscode: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(Color.pimBorder)
                .frame(width: 40, height: 4)
                .padding(.top, 8)
            
            VStack(spacing: 12) {
                Button(action: onSelectFaceID) {
                    HStack {
                        Image(systemName: "faceid")
                            .foregroundColor(.pimPrimary)
                        Text("Face ID")
                            .foregroundColor(.pimTextPrimary)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.pimCardBackground)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.pimBorder, lineWidth: 1)
                    )
                }
                
                Button(action: onSelectPasscode) {
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.pimPrimary)
                        Text("Passcode")
                            .foregroundColor(.pimTextPrimary)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.pimCardBackground)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.pimBorder, lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
}
