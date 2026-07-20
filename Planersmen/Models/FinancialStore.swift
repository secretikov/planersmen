import Foundation
import SwiftUI

enum GoalType: String, CaseIterable, Identifiable, Codable {
    case expense = "Трата"
    case investment = "Вложение"
    case debt = "Долг"
    case savings = "Накопление"

    var id: String { self.rawValue }

    var color: Color {
        switch self {
        case .expense: return .red
        case .investment: return .blue
        case .debt: return .orange
        case .savings: return .green
        }
    }
}

enum Priority: Int, CaseIterable, Identifiable, Codable, Comparable {
    case low = 1
    case medium = 2
    case high = 3

    var id: Int { self.rawValue }

    var title: String {
        switch self {
        case .low: return "Низкая"
        case .medium: return "Средняя"
        case .high: return "Высокая"
        }
    }

    static func < (lhs: Priority, rhs: Priority) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

struct FinancialGoal: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var type: GoalType
    var amountNeeded: Double
    var amountSaved: Double
    var priority: Priority

    init(
        id: UUID = UUID(),
        title: String,
        type: GoalType,
        amountNeeded: Double,
        amountSaved: Double = 0.0,
        priority: Priority = .medium
    ) {
        self.id = id
        self.title = title
        self.type = type
        self.amountNeeded = amountNeeded
        self.amountSaved = amountSaved
        self.priority = priority
    }

    var isCompleted: Bool {
        amountSaved >= amountNeeded
    }

    var progress: Double {
        guard amountNeeded > 0 else { return 0 }
        return min(amountSaved / amountNeeded, 1.0)
    }
}

final class FinancialStore: ObservableObject {
    @Published var goals: [FinancialGoal]

    init() {
        // Initial dummy data
        self.goals = [
            FinancialGoal(title: "Кредит за машину", type: .debt, amountNeeded: 15000, priority: .high),
            FinancialGoal(title: "Новый iPhone", type: .expense, amountNeeded: 80000, priority: .medium),
            FinancialGoal(title: "Акции Apple", type: .investment, amountNeeded: 20000, priority: .low),
            FinancialGoal(title: "Подушка безопасности", type: .savings, amountNeeded: 50000, priority: .high)
        ]
    }

    func add(_ goal: FinancialGoal) {
        goals.append(goal)
    }

    func update(_ goal: FinancialGoal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
        }
    }

    func delete(at offsets: IndexSet) {
        goals.remove(atOffsets: offsets)
    }

    // Distribute total income to goals based on priority
    func distributeIncome(_ totalIncome: Double) {
        // Reset all saved amounts first to recalculate based on total income
        for i in 0..<goals.count {
            goals[i].amountSaved = 0
        }

        var remainingIncome = totalIncome

        // Sort indices by priority (high to low)
        let sortedIndices = goals.indices.sorted {
            goals[$0].priority > goals[$1].priority
        }

        for index in sortedIndices {
            guard remainingIncome > 0 else { break }

            let needed = goals[index].amountNeeded - goals[index].amountSaved
            if needed > 0 {
                let amountToAllocate = min(remainingIncome, needed)
                goals[index].amountSaved += amountToAllocate
                remainingIncome -= amountToAllocate
            }
        }
    }
}
