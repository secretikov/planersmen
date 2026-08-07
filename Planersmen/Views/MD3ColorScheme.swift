import SwiftUI

struct MD3ColorScheme {
    let primary: Color
    let onPrimary: Color
    let primaryContainer: Color
    let onPrimaryContainer: Color

    let secondary: Color
    let onSecondary: Color
    let secondaryContainer: Color
    let onSecondaryContainer: Color

    let tertiary: Color
    let onTertiary: Color
    let tertiaryContainer: Color
    let onTertiaryContainer: Color

    let error: Color
    let onError: Color
    let errorContainer: Color
    let onErrorContainer: Color

    let background: Color
    let onBackground: Color
    let surface: Color
    let onSurface: Color
    let surfaceVariant: Color
    let onSurfaceVariant: Color
    let outline: Color
}

extension MD3ColorScheme {
    static let light = MD3ColorScheme(
        primary: Color(hex: "006874"),
        onPrimary: Color(hex: "FFFFFF"),
        primaryContainer: Color(hex: "97F0FF"),
        onPrimaryContainer: Color(hex: "001F24"),

        secondary: Color(hex: "4A6267"),
        onSecondary: Color(hex: "FFFFFF"),
        secondaryContainer: Color(hex: "CDE7EC"),
        onSecondaryContainer: Color(hex: "051F23"),

        tertiary: Color(hex: "525E7D"),
        onTertiary: Color(hex: "FFFFFF"),
        tertiaryContainer: Color(hex: "DAE2FF"),
        onTertiaryContainer: Color(hex: "0E1B37"),

        error: Color(hex: "BA1A1A"),
        onError: Color(hex: "FFFFFF"),
        errorContainer: Color(hex: "FFDAD6"),
        onErrorContainer: Color(hex: "410002"),

        background: Color(hex: "FBFDFD"),
        onBackground: Color(hex: "191C1D"),
        surface: Color(hex: "FBFDFD"),
        onSurface: Color(hex: "191C1D"),
        surfaceVariant: Color(hex: "DBE4E6"),
        onSurfaceVariant: Color(hex: "3F484A"),
        outline: Color(hex: "6F797A")
    )

    static let dark = MD3ColorScheme(
        primary: Color(hex: "4FD8EB"),
        onPrimary: Color(hex: "00363D"),
        primaryContainer: Color(hex: "004F58"),
        onPrimaryContainer: Color(hex: "97F0FF"),

        secondary: Color(hex: "B1CBD0"),
        onSecondary: Color(hex: "1C3438"),
        secondaryContainer: Color(hex: "334B4F"),
        onSecondaryContainer: Color(hex: "CDE7EC"),

        tertiary: Color(hex: "BAC6EA"),
        onTertiary: Color(hex: "24304D"),
        tertiaryContainer: Color(hex: "3B4664"),
        onTertiaryContainer: Color(hex: "DAE2FF"),

        error: Color(hex: "FFB4AB"),
        onError: Color(hex: "690005"),
        errorContainer: Color(hex: "93000A"),
        onErrorContainer: Color(hex: "FFDAD6"),

        background: Color(hex: "191C1D"),
        onBackground: Color(hex: "E1E3E3"),
        surface: Color(hex: "191C1D"),
        onSurface: Color(hex: "E1E3E3"),
        surfaceVariant: Color(hex: "3F484A"),
        onSurfaceVariant: Color(hex: "BFC8CA"),
        outline: Color(hex: "899294")
    )
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct MD3ColorSchemeKey: EnvironmentKey {
    static let defaultValue: MD3ColorScheme = .light
}

extension EnvironmentValues {
    var md3ColorScheme: MD3ColorScheme {
        get { self[MD3ColorSchemeKey.self] }
        set { self[MD3ColorSchemeKey.self] = newValue }
    }
}

struct MD3ThemeModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .environment(\.md3ColorScheme, colorScheme == .dark ? .dark : .light)
    }
}

extension View {
    func md3Theme() -> some View {
        modifier(MD3ThemeModifier())
    }
}
