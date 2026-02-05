//
//  Onboarding3View.swift
//  OnboardingApp
//
//  Created on 05/11/2025.
//

import SwiftUI
import StoreKit

struct Onboarding3View: View {
    @State private var selectedSource: SearchSource = .camera
    var onContinue: () -> Void
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 0) {
                    Image(.thirdPageBackground)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width)
                        .clipped()
                    
                    Spacer()
                }
                .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    VStack {
                        Text("Trusted by thousands of users")
                            .foregroundStyle(Color(hex: "121212"))
                            .font(.system(size: 22, weight: .semibold))
                            .padding(.bottom, 8)
                            .padding(.top, 32)
                        
                        Text("Real stories from people who searched\nsmarter with AI.")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "121212").opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Button(action: onContinue) {
                            Text("Next")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(Color(hex: "7454FF"))
                                .cornerRadius(8)
                        }
                        .padding(.top, 32)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .clipShape(RoundedCorners(radius: 44, corners: [.topLeft, .topRight]))
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct RadioButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color(hex: "7454FF") : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(Color(hex: "7454FF"))
                            .frame(width: 12, height: 12)
                    }
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(.white)
            .cornerRadius(15)
        }
        .padding(.bottom, 12)
    }
}
