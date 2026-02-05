import SwiftUI
import PhotosUI

struct LocatePlaceView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showSourcePicker = false
    @State private var showPreview = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Locate place", onBack: { dismiss() })
            
            VStack(spacing: 24) {
                Spacer()
                
                UploadCard {
                    showSourcePicker = true
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                PrimaryButton(title: "Find a place", action: {
                    if selectedImage != nil {
                        showPreview = true
                    }
                })
                .opacity(selectedImage != nil ? 1 : 0.5)
                .disabled(selectedImage == nil)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.pimBackground)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showSourcePicker) {
            SourcePickerSheet(
                onSelectFiles: {
                    showSourcePicker = false
                    showImagePicker = true
                },
                onSelectLibrary: {
                    showSourcePicker = false
                    showImagePicker = true
                }
            )
            .presentationDetents([.height(200)])
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage) {
                if selectedImage != nil {
                    showPreview = true
                }
            }
        }
        .navigationDestination(isPresented: $showPreview) {
            if let image = selectedImage {
                LocationPreviewView(image: image)
            }
        }
    }
}

#Preview {
    NavigationStack {
        LocatePlaceView()
    }
    .environmentObject(AppState())
}
