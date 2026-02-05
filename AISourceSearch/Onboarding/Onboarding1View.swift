//
//  Onboarding1View.swift
//  OnboardingApp
//
//  Created on 05/11/2025.
//

import SwiftUI

struct Onboarding1View: View {
    var onContinue: () -> Void
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 0) {
                    Image(.firstPageBackground)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width)
                        .clipped()

                    Spacer()
                }

                VStack {
                    Spacer()

                    VStack {
                        Text("Search smarter with AI")
                            .foregroundStyle(Color(hex: "121212"))
                            .font(.system(size: 22, weight: .semibold))
                            .padding(.bottom, 8)
                            .padding(.top, 32)

                        Text("Find similar images by simply taking or\nuploading a photo.")
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
            .ignoresSafeArea()
        }
    }
}

#Preview {
    Onboarding1View(onContinue: {})
}

