import SwiftUI

struct SearchPreviewView: View {
    @Environment(\.dismiss) var dismiss
    let image: UIImage
    
    @State private var selectedGender: GenderSelector.Gender = .man
    @State private var showCropMode = false
    @State private var showLoading = false
    @State private var showResults = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Search by photo", onBack: { dismiss() })
            
            if showCropMode {
                CropModeView(image: image, onDone: {
                    showCropMode = false
                })
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Who are you searching for?")
                            .font(.pimHeadline)
                            .foregroundColor(.pimTextPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        GenderSelector(selectedGender: $selectedGender)
                        
                        ZStack {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 350)
                                .cornerRadius(12)
                        }
                        
                        HStack(spacing: 24) {
                            ActionButton(icon: "arrow.uturn.left") { }
                            ActionButton(icon: "crop") { showCropMode = true }
                            ActionButton(icon: "arrow.uturn.right") { }
                        }
                        
                        Spacer()
                    }
                    .padding(20)
                }
                .background(Color.pimBackground)
                
                PrimaryButton(title: "Start search") {
                    showLoading = true
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showLoading) {
            SearchLoadingView(onComplete: {
                showLoading = false
                showResults = true
            })
        }
        .navigationDestination(isPresented: $showResults) {
            SearchResultsView(image: image, gender: selectedGender)
        }
    }
}

struct ActionButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.pimPrimary)
                .frame(width: 44, height: 44)
                .background(Color.pimCardBackground)
                .cornerRadius(22)
                .overlay(
                    Circle()
                        .stroke(Color.pimBorder, lineWidth: 1)
                )
        }
    }
}

struct CropModeView: View {
    let image: UIImage
    let onDone: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 20) {
                Text("Who are you searching for?")
                    .font(.pimHeadline)
                    .foregroundColor(.pimTextPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                GenderSelector(selectedGender: .constant(.man))
                
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 350)
                    
                    PhotoCropOverlay()
                }
                .cornerRadius(12)
                
                Button(action: {}) {
                    Image(systemName: "crop")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.pimPrimary)
                        .cornerRadius(8)
                }
                
                Spacer()
            }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: "424242"))
            
            PrimaryButton(title: "Done", action: onDone)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                .background(Color(hex: "424242"))
        }
    }
}

#Preview {
    SearchPreviewView(image: UIImage(systemName: "person.fill")!)
        .environmentObject(AppState())
}
