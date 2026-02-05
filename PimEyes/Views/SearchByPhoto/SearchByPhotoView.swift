import SwiftUI
import PhotosUI

struct SearchByPhotoView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showSourcePicker = false
    @State private var imageSource: ImageSource = .library
    @State private var showPreview = false
    
    enum ImageSource {
        case files, library
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Search by photo", onBack: { dismiss() })
            
            VStack(spacing: 24) {
                Spacer()
                
                UploadCard {
                    showSourcePicker = true
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                PrimaryButton(title: "Start search", action: {
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
                    imageSource = .files
                    showImagePicker = true
                },
                onSelectLibrary: {
                    showSourcePicker = false
                    imageSource = .library
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
                SearchPreviewView(image: image)
            }
        }
    }
}

struct SourcePickerSheet: View {
    let onSelectFiles: () -> Void
    let onSelectLibrary: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(Color.pimBorder)
                .frame(width: 40, height: 4)
                .padding(.top, 8)
            
            Text("Select a photo or file")
                .font(.pimHeadline)
                .foregroundColor(.pimTextPrimary)
            
            VStack(spacing: 12) {
                SourceButton(icon: "folder", title: "Files", action: onSelectFiles)
                SourceButton(icon: "photo.on.rectangle", title: "Library", action: onSelectLibrary)
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}

struct SourceButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.pimPrimary)
                Text(title)
                    .foregroundColor(.pimTextPrimary)
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.pimCardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.pimBorder, lineWidth: 1)
            )
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var onComplete: () -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else {
                return
            }
            
            provider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    self.parent.image = image as? UIImage
                    if self.parent.image != nil {
                        self.parent.onComplete()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SearchByPhotoView()
    }
    .environmentObject(AppState())
}
