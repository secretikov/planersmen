import SwiftUI

struct ContentView: View {
    @Environment(\.md3ColorScheme) var md3
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ShiftCalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Календарь")
                }
                .tag(0)

            // Placeholder for other tabs (e.g. statistics, settings)
            Text("Статистика")
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Статистика")
                }
                .tag(1)

            Text("Настройки")
                .tabItem {
                    Image(systemName: "gear")
                    Text("Настройки")
                }
                .tag(2)
        }
        .accentColor(md3.primary)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Shift.self, inMemory: true)
}
