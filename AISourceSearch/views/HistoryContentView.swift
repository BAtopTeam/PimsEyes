//
//  HistoryContentView.swift
//  BusterAI
//
//  Created by b on 06.11.2025.
//


import SwiftUI

struct HistoryContentView: View {
    @State private var history: [SearchHistoryItem] = []
    @State private var selectedResult: ReverseSearchStatusResponse? = nil
    @State private var showSettings = false
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("Recent")
                    .font(.system(size: 32).bold())
                    .foregroundStyle(.black)
                Spacer()
                Button {
                    showSettings = true
                } label: {
                    Image(.settings)
                }
            }
            .padding(.horizontal, 16)
            if history.isEmpty {
                VStack(spacing: 16) {
                    Image(.noFound)
                    
                    Text("No matches found")
                        .foregroundColor(.black)
                        .font(.title3)
                        .bold()
                    
                    Text("Try another angle or upload a different photo.")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(history.sorted(by: { $0.date > $1.date })) { item in
                            HistoryCell(item: item)
                                .onTapGesture {
                                    if let result = item.result {
                                        selectedResult = result
                                    }
                                }
                        }
                    }
                    .padding()
                    Spacer().frame(height: 200)
                }
            }
        }
        .background(Color(hex: "F5F5F5").ignoresSafeArea())
        .onAppear {
            history = HistoryManager.shared.loadHistory()
        }
        .fullScreenCover(isPresented: $showSettings) {
            SettingsView()
                .ignoresSafeArea()
        }
        .fullScreenCover(item: $selectedResult) { result in
            SearchResultView(searchResult: result)
                .ignoresSafeArea()
        }
    }
}

struct HistoryCell: View {
    let item: SearchHistoryItem
    
    var body: some View {
        VStack(spacing: 0) {
            if let uiImage = HistoryManager.shared.loadImage(filename: item.imageFilename) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 170, height: 160)
                    .clipped()
                    .cornerRadius(8)
            } else {
                Color.gray
                    .frame(width: 170, height: 160)
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.date.formatted(date: .abbreviated, time: .shortened))
                    .foregroundColor(.gray)
                    .font(.caption2)
            }
            .padding(6)
            .frame(width: 170, height: 40, alignment: .leading)
        }
    }
}
