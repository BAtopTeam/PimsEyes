//
//  OnboardingContainerView.swift
//  OnboardingApp
//
//  Created on 05/11/2025.
//

import SwiftUI
import ApphudSDK
import AppTrackingTransparency
import AdSupport
import StoreKit

struct OnboardingContainerView: View {
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false
    @State private var currentPage = 0
    @State private var showProcessing = false
    
    var body: some View {
        ZStack {
            if !showProcessing {
                ZStack(alignment: .top) {
                    TabView(selection: $currentPage) {
                        Onboarding1View(onContinue: {
                            withAnimation {
                                requestIDFAPermission()
                                currentPage = 1
                            }
                        })
                        .tag(0)
                        
                        Onboarding2View(onContinue: {
                            withAnimation {
                                requestRating()
                                currentPage = 2
                            }
                        })
                        .tag(1)
                        
                        Onboarding3View(onContinue: {
                            withAnimation {
                                currentPage = 3
                            }
                        })
                        .tag(2)
                        
                        Onboarding4View(onContinue: {
                            withAnimation {
                                currentPage = 4
                            }
                        })
                        .tag(3)
                        
                        SubscriptionView(onDismiss: {
                            withAnimation {
                                hasLaunchedBefore = true
                                showProcessing = true
                            }
                        })
                        .tag(4)
                    }
                    .onAppear {
                        UIScrollView.appearance().isScrollEnabled = false
                    }
                    .onDisappear {
                        UIScrollView.appearance().isScrollEnabled = true
                    }
                    .scrollDisabled(true)
                    .ignoresSafeArea()
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    if currentPage < 4 {
                        CustomPageControl(numberOfPages: 4, currentPage: currentPage)
                            .padding(.top, 16)
                    }
                }
                .background(Color(hex: "F4F6F8"))
            } else {
                ProcessingView()
                    .background(Color(hex: "F4F6F8"))
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
        }
        .scrollDisabled(true)
        .statusBar(hidden: false)
    }
    
    private func requestRating() {
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
    
    private func requestIDFAPermission() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .authorized:
                        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                        Apphud.setDeviceIdentifiers(idfa: idfa, idfv: UIDevice.current.identifierForVendor?.uuidString)
                        print("IDFA access granted:", ASIdentifierManager.shared().advertisingIdentifier)
                    case .denied:
                        print("IDFA denied")
                    case .notDetermined:
                        print("IDFA not determined")
                    case .restricted:
                        print("IDFA restricted")
                    @unknown default:
                        break
                    }
                }
            }
        }
    }
}

#Preview {
    OnboardingContainerView()
}

