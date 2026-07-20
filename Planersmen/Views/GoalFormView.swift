import SwiftUI

struct GoalFormView: View {
    @Environment(\.dismiss) private var dismiss
    private let initialGoal: FinancialGoal?
    private let onSave: (FinancialGoal) -> Void

    @State private var title = ""
    @State private var type: GoalType = .savings
    @State private var amountNeeded: Double = 0.0
    @State private var priority: Priority = .medium

    init(goal: FinancialGoal?, onSave: @escaping (FinancialGoal) -> Void) {
        self.initialGoal = goal
        self.onSave = onSave

        _title = State(initialValue: goal?.title ?? "")
        _type = State(initialValue: goal?.type ?? .savings)
        _amountNeeded = State(initialValue: goal?.amountNeeded ?? 0.0)
        _priority = State(initialValue: goal?.priority ?? .medium)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "#0F172A"), Color(hex: "#312E81"), Color(hex: "#1D4ED8")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                Form {
                    Section {
                        TextField("Название цели", text: $title)
                            .foregroundStyle(.white)

                        TextField("Сумма", value: $amountNeeded, format: .number)
                            .keyboardType(.decimalPad)
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(Color.white.opacity(0.08))

                    Section("Тип") {
                        Picker("Тип", selection: $type) {
                            ForEach(GoalType.allCases) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .listRowBackground(Color.white.opacity(0.08))

                    Section("Важность (Приоритет)") {
                        Picker("Важность", selection: $priority) {
                            ForEach(Priority.allCases) { p in
                                Text(p.title).tag(p)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .listRowBackground(Color.white.opacity(0.08))
                }
                .scrollContentBackground(.hidden)
                .background(.clear)
            }
            .navigationTitle(initialGoal == nil ? "Новая цель" : "Редактировать цель")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сохранить") {
                        save()
                    }
                    .bold()
                    .foregroundStyle(.white)
                }
            }
        }
    }

    private func save() {
        let goal = FinancialGoal(
            id: initialGoal?.id ?? UUID(),
            title: title.isEmpty ? "Новая цель" : title,
            type: type,
            amountNeeded: amountNeeded,
            amountSaved: initialGoal?.amountSaved ?? 0.0,
            priority: priority
        )
        onSave(goal)
        dismiss()
    }
}
