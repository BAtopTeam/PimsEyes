//
//  CustomTabBar.swift
//  OnboardingApp
//
//  Created on 06/11/2025.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    var onCameraTap: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            TabButton(
                icon: "home",
                title: "Main",
                isSelected: selectedTab == .home
            ) {
                selectedTab = .home
            }
            
            Spacer()
            
            Button(action: {
                onCameraTap()
            }) {
                Image(.camera)
                    .offset(y: -35)
            }
            
            Spacer()
            
            TabButton(
                icon: "clock",
                title: "Recent",
                isSelected: selectedTab == .history
            ) {
                selectedTab = .history
            }
        }
        .background(
            Color.white
        )
        .background(Color(hex: "F4F6F8").ignoresSafeArea())
    }
}

struct TabButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(isSelected ? "\(icon)" : "unselected\(icon.first!.uppercased() + String(icon.dropFirst()))")
                    .font(.system(size: 22, weight: .medium))
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isSelected ? Color(hex: "7454FF") : Color(hex: "121212"))
            }
            .frame(maxWidth: .infinity)
        }
    }
}


