import SwiftUI

struct GlassPanel<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .strokeBorder(.white.opacity(0.25), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.25), radius: 18, x: 0, y: 12)
            )
    }
}

extension Color {
    init(hex: String) {
        let sanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var hexValue: UInt64 = 0
        Scanner(string: sanitized).scanHexInt64(&hexValue)
        let mask: UInt64 = 0x000000FF
        let r = Double((hexValue >> 16) & mask) / 255
        let g = Double((hexValue >> 8) & mask) / 255
        let b = Double(hexValue & mask) / 255
        self.init(red: r, green: g, blue: b)
    }
}
