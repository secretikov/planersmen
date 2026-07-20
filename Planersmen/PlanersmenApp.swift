import SwiftUI

@main
struct PlanersmenApp: App {
    @StateObject private var shiftStore = ShiftStore()
    @StateObject private var financialStore = FinancialStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(shiftStore)
                .environmentObject(financialStore)
        }
    }
}
