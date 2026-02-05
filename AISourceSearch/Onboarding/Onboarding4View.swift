//
//  Onboarding4View.swift
//  OnboardingApp
//
//  Created on 05/11/2025.
//

import SwiftUI
import StoreKit

struct Onboarding4View: View {
    @State private var selectedGoal: SearchGoal = .similarImages
    var onContinue: () -> Void
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                
                Spacer()
                    .frame(height: geo.size.height * 0.08)
                
                // MARK: - Title
                Text("What do you want to do?")
                    .foregroundStyle(.black)
                    .font(.system(size: geo.size.height * 0.04, weight: .semibold))
                    .padding(.bottom, geo.size.height * 0.05)
                
                // MARK: - Radio Buttons
                VStack(spacing: geo.size.height * 0.015) {
                    ForEach(SearchGoal.allCases, id: \.self) { goal in
                        RadioButton(
                            title: goal.localizedName,
                            isSelected: selectedGoal == goal,
                            action: { selectedGoal = goal }
                        )
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // MARK: - Next Button
                Button(action: onContinue) {
                    Text("Next")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color(hex: "7454FF"))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, geo.size.height * 0.04)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}
