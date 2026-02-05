//
//  SearchView.swift
//  BusterAI
//
//  Created by b on 13.11.2025.
//

import SwiftUI

struct SearchImageView: View {
    @Environment(\.dismiss) var dismiss
    let image: UIImage
    
    @State private var showNetworkAlert = false
    @State private var taskId: String?
    @State private var progress: CGFloat = 0
    @State private var isProcessing = false
    @State private var result: ReverseSearchStatusResponse?
    @State private var showResult = false
    @State private var buttonText: String = "Start search"

    @State private var matchCounter = 0
    @State private var dotIndex = 0
    @State private var timer: Timer?
    
    var sendSearchResult: ((ReverseSearchStatusResponse?) -> Void)
    
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    @State private var showSubscribeView = false
    
    let activeDot = Color(hex: "7454FF")
    let inactiveDot = Color(hex: "7454FF").opacity(0.5)
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding()
                    }
                    Spacer()
                }
                
                Spacer()
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width - 32, height: 300)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                if isProcessing {
                    Text("Searching…")
                        .foregroundStyle(Color(hex: "121212").opacity(0.7))
                }
                if isProcessing {
                    VStack(spacing: 12) {
                        Text("\(matchCounter)")
                            .foregroundColor(Color(hex: "7454FF"))
                            .font(.title2)
                            .bold()
                        +
                        Text(" matches found")
                            .foregroundColor(.black)
                            .font(.title2)
                            .bold()
                        
                        HStack(spacing: 10) {
                            ForEach(0..<3) { i in
                                Circle()
                                    .fill(i == dotIndex ? activeDot : inactiveDot)
                                    .frame(width: 8, height: 8)
                            }
                        }
                    }
                }
                Spacer()
                Button(action: checkSubscriptionAndStartSearch) {
                    Text(buttonText)
                        .foregroundColor(isProcessing ? .black : .white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            Group {
                                if isProcessing {
                                    Color.gray.opacity(0.3)
                                } else {
                                   Color(hex: "7454FF")
                                }
                            }
                        )
                        .cornerRadius(8)
                        .opacity(isProcessing ? 0.7 : 1.0)
                }
                .disabled(isProcessing)
                .padding(.horizontal, 20)
                .padding(.top, 40)
                
                Spacer()
            }
            .padding(.top, 100)
        }
        .alert(isPresented: $showNetworkAlert) {
            Alert(
                title: Text("No Internet connection"),
                message: Text("Please check your network and try again."),
                dismissButton: .default(Text("OK"))
            )
        }

        .fullScreenCover(isPresented: $showSubscribeView) {
            SubscriptionView(onDismiss: {})
        }
    }
    
    // MARK: — SEARCH
    
    func checkSubscriptionAndStartSearch() {
        if showResult {
            sendSearchResult(result)
            return
        }
        if subscriptionManager.isSubscribed {
            startSearch()
        } else {
            showSubscribeView = true
        }
    }
    
    func startSearch() {
        isProcessing = true
        buttonText = "Waiting…"
        progress = 0
        matchCounter = 0
        dotIndex = 0
        
        startFakeAnimations()
        
        ReverseSearchAPI.shared.createSearchTask(image: image) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let id):
                    self.taskId = id
                    startPolling()
                case .failure:
                    stopAnimations()
                    isProcessing = false
                    showNetworkAlert = true
                }
            }
        }
    }
    
    func startFakeAnimations() {
        Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { t in
            if !isProcessing { t.invalidate(); return }
            if matchCounter < 20 {
                matchCounter += 1
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { t in
            if !isProcessing { t.invalidate(); return }
            dotIndex = (dotIndex + 1) % 3
        }
    }
    
    func stopAnimations() {
        isProcessing = false
        buttonText = "View results"
    }
    
    // MARK: — POLLING
    
    func startPolling() {
        guard let id = taskId else { return }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            ReverseSearchAPI.shared.getSearchStatus(taskId: id) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        let engines = ["google", "yandex", "bing"]
                        let completed = [
                            response.status?.google,
                            response.status?.yandex,
                            response.status?.bing
                        ].filter { $0 == "completed" }.count
                        
                        progress = CGFloat(completed) / CGFloat(engines.count)
                        
                        if completed == engines.count {
                            showResult = true
                            stopAnimations()
                            self.result = response
                            t.invalidate()
                            HistoryManager.shared.saveHistory(image: image, result: response)
                        }
                        
                    case .failure:
                        stopAnimations()
                        t.invalidate()
                        showNetworkAlert = true
                    }
                }
            }
        }
    }
}


