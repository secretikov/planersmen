import SwiftUI

// MARK: - MD3 Top App Bar
struct MD3TopAppBar: View {
    @Environment(\.md3ColorScheme) var md3
    let title: String
    let onTodayTap: () -> Void

    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(md3.onSurface)

            Spacer()

            Button(action: onTodayTap) {
                Text("Сегодня")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(md3.primaryContainer)
                    .foregroundColor(md3.onPrimaryContainer)
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(md3.surface)
    }
}

// MARK: - MD3 Floating Action Button (FAB)
struct MD3FloatingActionButton: View {
    @Environment(\.md3ColorScheme) var md3
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(md3.onPrimaryContainer)
                .frame(width: 56, height: 56)
                .background(md3.primaryContainer)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        }
    }
}

// MARK: - MD3 Segmented Button
struct MD3SegmentedButton: View {
    @Environment(\.md3ColorScheme) var md3
    let options: [String]
    @Binding var selection: String

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { index in
                let option = options[index]
                let isSelected = selection == option

                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selection = option
                    }
                }) {
                    Text(option)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(isSelected ? md3.onSecondaryContainer : md3.onSurface)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(isSelected ? md3.secondaryContainer : Color.clear)
                }
                .buttonStyle(PlainButtonStyle())

                if index < options.count - 1 {
                    Divider()
                        .frame(width: 1, height: 20)
                        .background(md3.outline)
                }
            }
        }
        .background(md3.surface)
        .clipShape(RoundedRectangle(cornerRadius: 100))
        .overlay(
            RoundedRectangle(cornerRadius: 100)
                .stroke(md3.outline, lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}
