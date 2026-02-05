import SwiftUI

struct LocationResultsView: View {
    @Environment(\.dismiss) var dismiss
    let image: UIImage
    
    let detectedLocation = "Place de Stanislas, Nancy, France"
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Location identified", onBack: { dismiss() })
            
            VStack(spacing: 20) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .cornerRadius(12)
                    .padding(.top, 20)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Image(systemName: "location.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.pimPrimary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("AI Analysis Result")
                            .font(.pimSmall)
                            .foregroundColor(.pimTextSecondary)
                        
                        Text(detectedLocation)
                            .font(.pimBody)
                            .foregroundColor(.pimTextPrimary)
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(Color.pimCardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.pimBorder, lineWidth: 1)
                )
                .pimCardShadow()
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.pimBackground)
            
            PrimaryButton(title: "Find out more location") {
                dismiss()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    LocationResultsView(image: UIImage(systemName: "building.2.fill")!)
        .environmentObject(AppState())
}
