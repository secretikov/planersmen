import SwiftUI
import SwiftData

@main
struct PlanersmenApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .md3Theme()
        }
        .modelContainer(for: Shift.self)
    }
}
