//
//  SubscriptionView.swift
//  BusterAI
//
//  Created by b on 13.11.2025.
//

import SwiftUI
import ApphudSDK
import StoreKit

// MARK: - Subscription View (Apphud)
struct SubscriptionView: View {
    @Environment(\.dismiss) var dismiss
    var onDismiss: (() -> Void)
    @State private var selectedPlan: PlanType = .annual
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    @State private var showCloseButton = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isRestoring = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Image(.paywallBack)
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea(edges: .top)
                Spacer()
            }
            
            VStack(spacing: 24) {
                HStack {
                    if showCloseButton {
                        Button(action: {
                            onDismiss()
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    Spacer()
                }
                .padding(.top, 60)
                .padding(.horizontal)
                
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    SubscriptionCard(title: "Search without limits")
                    SubscriptionCard(title: "Results from multiple sources")
                    SubscriptionCard(title: "Identify photos with AI")
                    SubscriptionCard(title: "View and save past results")
                }
                
                VStack(spacing: 20) {
                    // MARK: - Weekly Plan
                    if let weeklyProduct = subscriptionManager.products.first(where: { $0.productId.contains("week") }) {
                        SubscriptionPlanCard(
                            title: "Weekly",
                            subtitle: "",
                            details: subscriptionManager.getPriceString(for: weeklyProduct) + "/week",
                            isSelected: selectedPlan == .weekly
                        )
                        .onTapGesture { selectedPlan = .weekly }
                    }
                    // MARK: - Annual Plan
                    if let annualProduct = subscriptionManager.products.first(where: { $0.productId.contains("year") }) {
                        ZStack(alignment: .topTrailing) {
                            SubscriptionPlanCard(
                                title: "Yearly",
                                subtitle: subscriptionManager.getPriceString(for: annualProduct) + " / year",
                                details: String(format: "$%.1f/week", subscriptionManager.getPriceValue(for: annualProduct) / 52),
                                isSelected: selectedPlan == .annual
                            )
                            .onTapGesture { selectedPlan = .annual }
                            
                            Text("Save 85%")
                                .padding(.horizontal, 16)
                                .padding(.vertical, 3)
                                .background(Color(hex: "7454FF"))
                                .foregroundStyle(.white)
                                .cornerRadius(15)
                                .offset(x: -15, y: -15)
                        }
                    }
                    
                    // MARK: - Purchase Button
                    Button(action: purchaseSelectedPlan) {
                        Text("Start now")
                            .foregroundColor(.white)
                            .font(.system(size: 17, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .frame(height: 52)
                            .background(Color(hex: "7454FF"))
                            .cornerRadius(8)
                    }
                    
                    VStack() {
                        HStack(spacing: 12) {
                            Link("Privacy Policy", destination: URL(string: "https://docs.google.com/document/d/1EKSY5Cg5g8qeFV8v67lw_sRD_9GRGAQGYrx7bZzZYCM/edit?usp=sharing")!)
                            Text("|")
                            Button {
                                restorePurchases()
                            } label: {
                                Text("Recover")
                            }
                            Text("|")
                            Link("Terms of Use", destination: URL(string: "https://docs.google.com/document/d/1EawiOaouhDCNeyW5M_i8Oac6u3jCVZTr9nhpepVDTW4/edit?usp=sharing")!)
                        }
                        .font(.caption)
                        .foregroundColor(.gray)
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .padding(.bottom, 10)
                .background(Color(hex: "F5F5F5"))
                .clipShape(RoundedCorners(radius: 16, corners: [.topLeft, .topRight]))
            }
        }
        .onAppear(perform: {
            subscriptionManager.loadProducts()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation {
                    showCloseButton = true
                }
            }
        })
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Subscription"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "F5F5F5"))
        .ignoresSafeArea()
    }
    
    // MARK: - Selected Product
    private func selectedProduct() -> ApphudProduct? {
        switch selectedPlan {
        case .annual:
            return subscriptionManager.products.first(where: { $0.productId.contains("year") })
        case .weekly:
            return subscriptionManager.products.first(where: { $0.productId.contains("week") })
        }
    }
    
    // MARK: - Purchase Action
    private func purchaseSelectedPlan() {
        guard let product = selectedProduct() else { return }
        subscriptionManager.purchase(product: product) { success, error in
            if let error = error {
                print("❌ Purchase error: \(error)")
            } else {
                dismiss()
                print("✅ Purchase success: \(success)")
            }
        }
    }
    
    private func restorePurchases() {
        isRestoring = true
        subscriptionManager.restorePurchases { success, message in
            isRestoring = false
            alertMessage = message ?? (success ? "Subscription restored successfully" : "Couldn't restore subscription")
            showAlert = true
        }
    }
}

// MARK: - Plan Type
enum PlanType {
    case annual, weekly
}

// MARK: - Subscription Plan Card
struct SubscriptionPlanCard: View {
    let title: String
    let subtitle: String
    let details: String
    let isSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                }
            }
            Spacer()
            Text(details)
                .font(Font.system(size: 16, weight: .medium))
                .foregroundColor(.black)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 65)
        .background(isSelected ? Color(hex: "7454FF").opacity(0.2) : Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color(hex: "7454FF") : Color(hex: "E0E0E0"), lineWidth: 2)
        )
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct SubscriptionCard: View {
    let title: String
    var body: some View {
        HStack {
            Image(.checkCircle)
            Text(title)
                .foregroundStyle(.white)
        }
    }
}
