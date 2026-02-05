import SwiftUI

struct MessageLoadingView: View {
    let onComplete: () -> Void
    
    @State private var animatingDots = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                LinearGradient.pimHeaderGradient
                    .ignoresSafeArea(edges: .top)
                
                HStack {
                    Button(action: {}) {
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
            
            VStack {
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color.pimPrimary)
                            .frame(width: 12, height: 12)
                            .scaleEffect(animatingDots ? 1.0 : 0.5)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatForever()
                                    .delay(Double(index) * 0.2),
                                value: animatingDots
                            )
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.pimBackground)
        }
        .onAppear {
            animatingDots = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onComplete()
            }
        }
    }
}

#Preview {
    MessageLoadingView(onComplete: {})
}
