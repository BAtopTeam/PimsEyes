import SwiftUI

struct PaywallView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    @State private var selectedPlan: SubscriptionPlan = .annual
    
    enum SubscriptionPlan {
        case annual
        case weekly
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.pimBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    ZStack {
                        ForEach(0..<8, id: \.self) { index in
                            Circle()
                                .fill(Color.pimAccent.opacity(0.2))
                                .frame(width: CGFloat.random(in: 20...40))
                                .offset(
                                    x: CGFloat.random(in: -100...100),
                                    y: CGFloat.random(in: -40...80)
                                )
                        }
                        
                        VStack {
                            Image(systemName: "scope")
                                .font(.system(size: 60))
                                .foregroundColor(.pimPrimary)
                                .padding()
                                .background(
                                    Circle()
                                        .fill(Color.pimPrimary.opacity(0.1))
                                )
                        }
                    }
                    .frame(height: 180)
                    .padding(.top, 40)
                    
                    Text("Unlock the full power of AI")
                        .font(.pimTitle)
                        .foregroundColor(.pimTextPrimary)
                        .multilineTextAlignment(.center)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        FeatureRow(text: "Find him by photo")
                        FeatureRow(text: "Spot red flags instantly")
                        FeatureRow(text: "Unlimited searches")
                    }
                    .padding(.horizontal, 40)
                    
                    VStack(spacing: 12) {
                        SubscriptionOption(
                            title: "Annual",
                            pricePerWeek: "$0.67 / week",
                            totalPrice: "$34.99 / year",
                            savingsTag: "Save 41%",
                            isSelected: selectedPlan == .annual
                        ) {
                            selectedPlan = .annual
                        }
                        
                        SubscriptionOption(
                            title: "Weekly",
                            pricePerWeek: "$2.24 / week",
                            totalPrice: nil,
                            savingsTag: nil,
                            isSelected: selectedPlan == .weekly
                        ) {
                            selectedPlan = .weekly
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Text("Cancel Anytime")
                        .font(.pimCaption)
                        .foregroundColor(.pimTextSecondary)
                    
                    PrimaryButton(title: "Continue") {
                        appState.completeOnboarding()
                        dismiss()
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
                    .padding(.bottom, 32)
                }
            }
            
            Button(action: {
                appState.completeOnboarding()
                dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.pimTextSecondary)
                    .padding(12)
            }
            .padding(.top, 8)
            .padding(.trailing, 8)
        }
    }
}

struct FeatureRow: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.pimPrimary)
            
            Text(text)
                .font(.pimBody)
                .foregroundColor(.pimTextPrimary)
        }
    }
}

struct SubscriptionOption: View {
    let title: String
    let pricePerWeek: String
    let totalPrice: String?
    let savingsTag: String?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .stroke(isSelected ? Color.pimPrimary : Color.pimBorder, lineWidth: 2)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .fill(isSelected ? Color.pimPrimary : Color.clear)
                            .frame(width: 12, height: 12)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.pimHeadline)
                        .foregroundColor(.pimTextPrimary)
                    
                    Text(pricePerWeek)
                        .font(.pimSmall)
                        .foregroundColor(.pimTextSecondary)
                }
                
                Spacer()
                
                if let savings = savingsTag {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(savings)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.pimAccent)
                            .cornerRadius(10)
                        
                        if let total = totalPrice {
                            Text(total)
                                .font(.pimCaption)
                                .foregroundColor(.pimTextPrimary)
                        }
                    }
                } else if let total = totalPrice {
                    Text(total)
                        .font(.pimCaption)
                        .foregroundColor(.pimTextPrimary)
                } else {
                    Text(pricePerWeek.replacingOccurrences(of: " / week", with: ""))
                        .font(.pimCaption)
                        .foregroundColor(.pimTextPrimary)
                }
            }
            .padding(16)
            .background(Color.pimCardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.pimPrimary : Color.pimBorder, lineWidth: isSelected ? 2 : 1)
            )
        }
    }
}

#Preview {
    PaywallView()
        .environmentObject(AppState())
}
