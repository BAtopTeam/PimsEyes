import SwiftUI

struct RateUsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Rate us", onBack: { dismiss() })
            
            VStack(spacing: 24) {
                Spacer()
                
                ZStack {
                    ForEach(0..<5, id: \.self) { index in
                        Image(systemName: "star.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.yellow)
                            .offset(
                                x: CGFloat.random(in: -80...80),
                                y: CGFloat.random(in: -60...60)
                            )
                            .opacity(0.6)
                    }
                    
                    Circle()
                        .fill(Color.pimPrimary.opacity(0.1))
                        .frame(width: 180, height: 180)
                        .overlay(
                            Image(systemName: "person.fill.viewfinder")
                                .font(.system(size: 60))
                                .foregroundColor(.pimPrimary)
                        )
                }
                .frame(height: 200)
                
                Text("Help others stay safe")
                    .font(.pimTitle)
                    .foregroundColor(.pimTextPrimary)
                
                Text("our rating shields others from heartbreak and online scams.")
                    .font(.pimBody)
                    .foregroundColor(.pimTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                PrimaryButton(title: "Rate now") {
                    dismiss()
                }
                .padding(.horizontal, 24)
                
                Button(action: { dismiss() }) {
                    Text("Maybe later")
                        .font(.pimBody)
                        .foregroundColor(.pimTextSecondary)
                }
                .padding(.bottom, 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.pimBackground)
        }
    }
}

#Preview {
    RateUsView()
}
