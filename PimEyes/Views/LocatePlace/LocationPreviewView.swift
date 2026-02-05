import SwiftUI

struct LocationPreviewView: View {
    @Environment(\.dismiss) var dismiss
    let image: UIImage
    
    @State private var showLoading = false
    @State private var showResults = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Locate place", onBack: { dismiss() })
            
            VStack(spacing: 20) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 350)
                    .cornerRadius(12)
                    .padding(.top, 20)
                
                HStack(spacing: 24) {
                    ActionButton(icon: "arrow.uturn.left") { }
                    ActionButton(icon: "crop") { }
                    ActionButton(icon: "arrow.uturn.right") { }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.pimBackground)
            
            PrimaryButton(title: "Find a place") {
                showLoading = true
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showLoading) {
            LocationLoadingView(onComplete: {
                showLoading = false
                showResults = true
            })
        }
        .navigationDestination(isPresented: $showResults) {
            LocationResultsView(image: image)
        }
    }
}

#Preview {
    LocationPreviewView(image: UIImage(systemName: "building.2.fill")!)
        .environmentObject(AppState())
}
