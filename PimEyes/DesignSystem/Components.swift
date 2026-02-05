import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.pimHeadline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    RoundedRectangle(cornerRadius: 27)
                        .fill(isEnabled ? Color.pimAccent : Color.gray)
                )
                .pimButtonShadow()
        }
        .disabled(!isEnabled)
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.pimBody)
                .foregroundColor(.pimPrimary)
        }
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let buttonTitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(.pimPrimary)
            
            Text(title)
                .font(.pimHeadline)
                .foregroundColor(.pimTextPrimary)
                .multilineTextAlignment(.center)
            
            Text(description)
                .font(.pimCaption)
                .foregroundColor(.pimTextSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            PrimaryButton(title: buttonTitle, action: action)
                .padding(.horizontal, 24)
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(Color.pimCardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.pimBorder, lineWidth: 1)
        )
        .pimCardShadow()
    }
}

struct HeaderView: View {
    let title: String
    var showBackButton: Bool = true
    var onBack: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            LinearGradient.pimHeaderGradient
                .ignoresSafeArea(edges: .top)
            
            HStack {
                if showBackButton {
                    Button(action: { onBack?() }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
                
                Text(title)
                    .font(.pimHeadline)
                    .foregroundColor(.white)
                
                Spacer()
                
                if showBackButton {
                    Color.clear.frame(width: 20, height: 20)
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 56)
    }
}

struct UploadCard: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                ZStack {
                    Image(systemName: "person.crop.rectangle")
                        .font(.system(size: 40))
                        .foregroundColor(.pimPrimary)
                    
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.pimAccent)
                        .offset(x: 20, y: -15)
                }
                
                Text("Upload a photo")
                    .font(.pimBody)
                    .foregroundColor(.pimTextPrimary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .background(Color.pimCardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        Color.pimPrimary,
                        style: StrokeStyle(lineWidth: 2, dash: [8])
                    )
            )
        }
    }
}

struct GenderSelector: View {
    @Binding var selectedGender: Gender
    
    enum Gender: String, CaseIterable {
        case woman = "Woman"
        case man = "Man"
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(Gender.allCases, id: \.self) { gender in
                Button(action: { selectedGender = gender }) {
                    Text(gender.rawValue)
                        .font(.pimBody)
                        .foregroundColor(selectedGender == gender ? .white : .pimPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selectedGender == gender ? Color.pimPrimary : Color.clear)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.pimPrimary, lineWidth: 1)
                        )
                }
            }
        }
    }
}

struct LoadingView: View {
    let title: String
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.pimPrimary)
                        .frame(width: 12, height: 12)
                        .scaleEffect(isAnimating ? 1.0 : 0.5)
                        .animation(
                            Animation.easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                            value: isAnimating
                        )
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.pimBackground)
        .onAppear {
            isAnimating = true
        }
    }
}

struct RiskCircle: View {
    let percentage: Int
    
    private var riskColor: Color {
        switch percentage {
        case 0..<30: return .pimSuccess
        case 30..<60: return .pimWarning
        default: return .pimDanger
        }
    }
    
    private var riskLabel: String {
        switch percentage {
        case 0..<30: return "Low risk level"
        case 30..<60: return "Medium risk level"
        default: return "High risk level"
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(Color.pimBorder, lineWidth: 12)
                
                Circle()
                    .trim(from: 0, to: CGFloat(percentage) / 100)
                    .stroke(
                        AngularGradient(
                            colors: [.pimSuccess, .pimWarning, .pimDanger],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                Text("\(percentage)%")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.pimTextPrimary)
            }
            .frame(width: 120, height: 120)
            
            Text(riskLabel)
                .font(.pimCaption)
                .foregroundColor(riskColor)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    var showChevron: Bool = true
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.pimPrimary)
                    .frame(width: 24)
                
                Text(title)
                    .font(.pimBody)
                    .foregroundColor(.pimTextPrimary)
                
                Spacer()
                
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.pimTextSecondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.pimCardBackground)
        }
    }
}

struct TabItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 22))
            Text(title)
                .font(.pimSmall)
        }
        .foregroundColor(isSelected ? .pimPrimary : .pimTextSecondary)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.pimCaption)
                .foregroundColor(isSelected ? .white : .pimPrimary)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.pimPrimary : Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.pimPrimary, lineWidth: 1)
                )
        }
    }
}

struct PhotoCropOverlay: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let bracketLength: CGFloat = 30
                let bracketWidth: CGFloat = 4
                let padding: CGFloat = 20
                
                VStack(alignment: .leading, spacing: 0) {
                    Rectangle()
                        .fill(Color.pimPrimary)
                        .frame(width: bracketLength, height: bracketWidth)
                    Rectangle()
                        .fill(Color.pimPrimary)
                        .frame(width: bracketWidth, height: bracketLength - bracketWidth)
                }
                .position(x: padding + bracketLength/2, y: padding + bracketLength/2)
                
                VStack(alignment: .trailing, spacing: 0) {
                    Rectangle()
                        .fill(Color.pimPrimary)
                        .frame(width: bracketLength, height: bracketWidth)
                    Rectangle()
                        .fill(Color.pimPrimary)
                        .frame(width: bracketWidth, height: bracketLength - bracketWidth)
                }
                .position(x: geometry.size.width - padding - bracketLength/2, y: padding + bracketLength/2)
                
                VStack(alignment: .leading, spacing: 0) {
                    Rectangle()
                        .fill(Color.pimPrimary)
                        .frame(width: bracketWidth, height: bracketLength - bracketWidth)
                    Rectangle()
                        .fill(Color.pimPrimary)
                        .frame(width: bracketLength, height: bracketWidth)
                }
                .position(x: padding + bracketLength/2, y: geometry.size.height - padding - bracketLength/2)
                
                VStack(alignment: .trailing, spacing: 0) {
                    Rectangle()
                        .fill(Color.pimPrimary)
                        .frame(width: bracketWidth, height: bracketLength - bracketWidth)
                    Rectangle()
                        .fill(Color.pimPrimary)
                        .frame(width: bracketLength, height: bracketWidth)
                }
                .position(x: geometry.size.width - padding - bracketLength/2, y: geometry.size.height - padding - bracketLength/2)
            }
        }
    }
}
