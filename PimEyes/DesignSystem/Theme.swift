import SwiftUI

extension Color {
    static let pimPrimary = Color(hex: "1565C0")
    static let pimPrimaryDark = Color(hex: "0D47A1")
    static let pimAccent = Color(hex: "E91E63")
    static let pimAccentLight = Color(hex: "F06292")
    static let pimBackground = Color(hex: "F5F5F5")
    static let pimCardBackground = Color.white
    static let pimTextPrimary = Color(hex: "212121")
    static let pimTextSecondary = Color(hex: "757575")
    static let pimBorder = Color(hex: "E0E0E0")
    static let pimSuccess = Color(hex: "4CAF50")
    static let pimWarning = Color(hex: "FF9800")
    static let pimDanger = Color(hex: "F44336")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Font {
    static let pimTitle = Font.system(size: 24, weight: .bold, design: .rounded)
    static let pimHeadline = Font.system(size: 18, weight: .semibold, design: .rounded)
    static let pimBody = Font.system(size: 16, weight: .regular)
    static let pimCaption = Font.system(size: 14, weight: .regular)
    static let pimSmall = Font.system(size: 12, weight: .regular)
    static let pimLogo = Font.custom("Pacifico-Regular", size: 28)
}

extension LinearGradient {
    static let pimHeaderGradient = LinearGradient(
        colors: [Color.pimPrimary, Color.pimPrimaryDark],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let pimButtonGradient = LinearGradient(
        colors: [Color.pimAccent, Color.pimAccentLight],
        startPoint: .leading,
        endPoint: .trailing
    )
}

extension View {
    func pimCardShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
    
    func pimButtonShadow() -> some View {
        self.shadow(color: Color.pimAccent.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}
