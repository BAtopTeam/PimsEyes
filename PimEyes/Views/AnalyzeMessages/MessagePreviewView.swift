import SwiftUI

struct MessagePreviewView: View {
    @Environment(\.dismiss) var dismiss
    let image: UIImage
    
    @State private var showLoading = false
    @State private var showResults = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Analyze messages", onBack: { dismiss() })
            
            ScrollView {
                VStack(spacing: 20) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
                        
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(8)
                            .padding(8)
                    }
                    .frame(maxHeight: 400)
                    .padding(.horizontal, 20)
                    
                    HStack(spacing: 24) {
                        ActionButton(icon: "arrow.uturn.left") { }
                        ActionButton(icon: "crop") { }
                        ActionButton(icon: "arrow.uturn.right") { }
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 20)
            }
            .background(Color.pimBackground)
            
            PrimaryButton(title: "Start search") {
                showLoading = true
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showLoading) {
            MessageLoadingView(onComplete: {
                showLoading = false
                showResults = true
            })
        }
        .navigationDestination(isPresented: $showResults) {
            MessageResultsView(image: image)
        }
    }
}

#Preview {
    MessagePreviewView(image: UIImage(systemName: "message.fill")!)
        .environmentObject(AppState())
}
