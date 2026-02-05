import SwiftUI

struct PasscodeView: View {
    @Environment(\.dismiss) var dismiss
    @State private var enteredDigits: [Int] = []
    @State private var currentStep = 0
    
    private let maxDigits = 4
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                LinearGradient.pimHeaderGradient
                    .ignoresSafeArea(edges: .top)
                
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Passcode")
                        .font(.pimHeadline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 20, height: 20)
                }
                .padding(.horizontal, 16)
            }
            .frame(height: 56)
            
            VStack(spacing: 32) {
                Spacer()
                
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 40))
                    .foregroundColor(.pimPrimary)
                    .padding(20)
                    .background(
                        Circle()
                            .stroke(Color.pimPrimary, lineWidth: 2)
                    )
                
                Text("Welcome")
                    .font(.pimTitle)
                    .foregroundColor(.pimTextPrimary)
                
                HStack(spacing: 16) {
                    ForEach(0..<maxDigits, id: \.self) { index in
                        Circle()
                            .fill(index < enteredDigits.count ? Color.pimPrimary : Color.pimBorder)
                            .frame(width: 14, height: 14)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    ForEach(0..<3) { row in
                        HStack(spacing: 32) {
                            ForEach(1..<4) { col in
                                let number = row * 3 + col
                                NumberButton(number: number) {
                                    addDigit(number)
                                }
                            }
                        }
                    }
                    
                    HStack(spacing: 32) {
                        Button(action: { dismiss() }) {
                            Text("Skip")
                                .font(.pimBody)
                                .foregroundColor(.pimTextSecondary)
                                .frame(width: 70, height: 70)
                        }
                        
                        NumberButton(number: 0) {
                            addDigit(0)
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "faceid")
                                .font(.system(size: 28))
                                .foregroundColor(.pimPrimary)
                                .frame(width: 70, height: 70)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.pimBackground)
        }
    }
    
    private func addDigit(_ digit: Int) {
        guard enteredDigits.count < maxDigits else { return }
        enteredDigits.append(digit)
        
        if enteredDigits.count == maxDigits {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                dismiss()
            }
        }
    }
}

struct NumberButton: View {
    let number: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(number)")
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(.pimTextPrimary)
                .frame(width: 70, height: 70)
                .background(Color.pimCardBackground)
                .cornerRadius(35)
        }
    }
}

#Preview {
    PasscodeView()
}
