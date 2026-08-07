import SwiftUI

struct MD3ShiftCard: View {
    @Environment(\.md3ColorScheme) var md3
    let shift: Shift
    let onTap: () -> Void

    // Determine MD3 container colors based on shift type
    private var cardColors: (bg: Color, fg: Color) {
        switch shift.type {
        case .day:
            return (md3.primaryContainer, md3.onPrimaryContainer)
        case .night:
            return (md3.tertiaryContainer, md3.onTertiaryContainer)
        case .overtime:
            return (md3.errorContainer, md3.onErrorContainer)
        case .timeOff:
            return (md3.secondaryContainer, md3.onSecondaryContainer)
        }
    }

    // Formatting time
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "\(formatter.string(from: shift.startTime)) - \(formatter.string(from: shift.endTime))"
    }

    @State private var hapticTrigger = false

    var body: some View {
        Button(action: {
            hapticTrigger.toggle()
            onTap()
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(shift.type.rawValue)
                        .font(.headline)
                        .foregroundColor(cardColors.fg)

                    Spacer()

                    Text(timeString)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(cardColors.fg.opacity(0.1))
                        .foregroundColor(cardColors.fg)
                        .clipShape(Capsule())
                }

                if !shift.notes.isEmpty {
                    Text(shift.notes)
                        .font(.body)
                        .foregroundColor(cardColors.fg.opacity(0.8))
                        .lineLimit(2)
                }

                if shift.rate > 0 {
                    HStack {
                        Spacer()
                        Text(String(format: "Ставка: %.2f", shift.rate))
                            .font(.caption2)
                            .foregroundColor(cardColors.fg.opacity(0.7))
                    }
                }
            }
            .padding(16)
            .background(cardColors.bg)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            // Minimal shadow for tonal elevation effect in MD3
            .shadow(color: cardColors.bg.opacity(0.3), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .sensoryFeedback(.impact, trigger: hapticTrigger) // Native haptic feedback
    }
}
