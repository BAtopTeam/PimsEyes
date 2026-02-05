import SwiftUI

struct MessageResultsView: View {
    @Environment(\.dismiss) var dismiss
    let image: UIImage
    
    @State private var showFeedbackDialog = false
    
    let riskPercentage = 80
    let redFlags: [RedFlag] = [
        RedFlag(title: "Suspicious language detected", phrase: "I've been waiting for 10 minutes..."),
        RedFlag(title: "Suspicious language detected", phrase: "I've been waiting for 10 minutes..."),
        RedFlag(title: "Suspicious language detected", phrase: "I've been waiting for 10 minutes...")
    ]
    let recommendations: [Recommendation] = [
        Recommendation(title: "Suspicious language detected", phrase: "I've been waiting for 10 minutes..."),
        Recommendation(title: "Suspicious language detected", phrase: "I've been waiting for 10 minutes..."),
        Recommendation(title: "Suspicious language detected", phrase: "I've been waiting for 10 minutes...")
    ]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack {
                    Color.pimDanger
                        .ignoresSafeArea(edges: .top)
                    
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Text("Scanning for risks...")
                            .font(.pimHeadline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Color.clear.frame(width: 20, height: 20)
                    }
                    .padding(.horizontal, 16)
                }
                .frame(height: 56)
                
                ScrollView {
                    VStack(spacing: 20) {
                        HStack {
                            Text("Risk analysis complete")
                                .font(.pimHeadline)
                                .foregroundColor(.pimTextPrimary)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.pimPrimary)
                        }
                        
                        Text("High risk detected in this message")
                            .font(.pimCaption)
                            .foregroundColor(.pimTextSecondary)
                        
                        RiskCircle(percentage: riskPercentage)
                            .padding(.vertical, 10)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Red flags")
                                .font(.pimHeadline)
                                .foregroundColor(.pimTextPrimary)
                            
                            ForEach(redFlags) { flag in
                                RedFlagRow(flag: flag)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recommendations")
                                .font(.pimHeadline)
                                .foregroundColor(.pimTextPrimary)
                            
                            ForEach(recommendations) { rec in
                                RecommendationRow(recommendation: rec)
                            }
                        }
                    }
                    .padding(20)
                }
                .background(Color.pimBackground)
                
                PrimaryButton(title: "Check another message") {
                    dismiss()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            
            if showFeedbackDialog {
                FeedbackDialog(
                    onDismiss: { showFeedbackDialog = false },
                    onThumbsUp: { showFeedbackDialog = false },
                    onThumbsDown: { showFeedbackDialog = false }
                )
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showFeedbackDialog = true
            }
        }
    }
}

struct RedFlag: Identifiable {
    let id = UUID()
    let title: String
    let phrase: String
}

struct Recommendation: Identifiable {
    let id = UUID()
    let title: String
    let phrase: String
}

struct RedFlagRow: View {
    let flag: RedFlag
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.pimWarning)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(flag.title)
                    .font(.pimBody)
                    .foregroundColor(.pimTextPrimary)
                
                Text("Phrase: \"\(flag.phrase)\"")
                    .font(.pimSmall)
                    .foregroundColor(.pimTextSecondary)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.pimCardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.pimBorder, lineWidth: 1)
        )
    }
}

struct RecommendationRow: View {
    let recommendation: Recommendation
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "checkmark.circle")
                .foregroundColor(.pimSuccess)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recommendation.title)
                    .font(.pimBody)
                    .foregroundColor(.pimTextPrimary)
                
                Text("Phrase: \"\(recommendation.phrase)\"")
                    .font(.pimSmall)
                    .foregroundColor(.pimTextSecondary)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.pimCardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.pimBorder, lineWidth: 1)
        )
    }
}

struct FeedbackDialog: View {
    let onDismiss: () -> Void
    let onThumbsUp: () -> Void
    let onThumbsDown: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }
            
            VStack(spacing: 16) {
                Text("Was this analysis helpful?")
                    .font(.pimHeadline)
                    .foregroundColor(.pimTextPrimary)
                
                Text("Your feedback helps us improve our detection accuracy")
                    .font(.pimCaption)
                    .foregroundColor(.pimTextSecondary)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 16) {
                    Button(action: onThumbsDown) {
                        Image(systemName: "hand.thumbsdown")
                            .font(.system(size: 24))
                            .foregroundColor(.pimTextSecondary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.pimBackground)
                            .cornerRadius(8)
                    }
                    
                    Button(action: onThumbsUp) {
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.pimAccent)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(24)
            .background(Color.pimCardBackground)
            .cornerRadius(16)
            .pimCardShadow()
            .padding(40)
        }
    }
}

#Preview {
    MessageResultsView(image: UIImage(systemName: "message.fill")!)
        .environmentObject(AppState())
}
