//
//  Onboarding2View.swift
//  OnboardingApp
//
//  Created on 05/11/2025.
//

import SwiftUI

struct Onboarding2View: View {
    var onContinue: () -> Void
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing: 0) {
                    Image(.secondPageBackground)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width)
                        .clipped()
                        .padding(.top, 110)
                    
                    Spacer()
                }
                .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    VStack {
                        Text("One photo — many results")
                            .foregroundStyle(Color(hex: "121212"))
                            .font(.system(size: 22, weight: .semibold))
                            .padding(.bottom, 8)
                            .padding(.top, 32)
                        
                        Text("Your image is searched across\nmultiple engines at once.")
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


#Preview {
    Onboarding2View(onContinue: {})
}

