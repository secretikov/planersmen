import SwiftUI

struct FinancesView: View {
    @EnvironmentObject var shiftStore: ShiftStore
    @EnvironmentObject var financialStore: FinancialStore
    @State private var isPresentingEditor = false
    @State private var editingGoal: FinancialGoal?

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "#0F172A"), Color(hex: "#1E293B"), Color(hex: "#312E81")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Доходы и Цели")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        Text("Умное распределение заработка")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    HStack(spacing: 16) {
                        FinanceStatPanel(
                            title: "Всего заработано",
                            value: String(format: "%.2f", shiftStore.totalIncome),
                            icon: "banknote",
                            color: .green
                        )

                        FinanceStatPanel(
                            title: "В среднем за день",
                            value: String(format: "%.2f", shiftStore.averageDailyIncome),
                            icon: "chart.bar.fill",
                            color: .blue
                        )
                    }
                    .padding(.horizontal)

                    if financialStore.goals.isEmpty {
                        GlassPanel {
                            VStack(spacing: 8) {
                                Image(systemName: "target")
                                    .font(.system(size: 44))
                                    .foregroundStyle(.secondary)
                                    .padding(.bottom, 4)
                                Text("Пока нет целей")
                                    .font(.title2.weight(.bold))
                                    .foregroundStyle(.white)
                                Text("Добавьте расходы, долги или вложения для распределения дохода")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        Spacer()
                    } else {
                        List {
                            ForEach(financialStore.goals) { goal in
                                GoalRow(goal: goal) {
                                    editingGoal = goal
                                    isPresentingEditor = true
                                }
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                            }
                            .onDelete { indexSet in
                                financialStore.delete(at: indexSet)
                                financialStore.distributeIncome(shiftStore.totalIncome)
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .background(.clear)
                        .listStyle(.plain)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        editingGoal = nil
                        isPresentingEditor = true
                    } label: {
                        Label("Добавить", systemImage: "plus")
                    }
                    .foregroundStyle(.white)
                }
            }
            .sheet(isPresented: $isPresentingEditor) {
                GoalFormView(goal: editingGoal) { newGoal in
                    if let _ = editingGoal {
                        financialStore.update(newGoal)
                    } else {
                        financialStore.add(newGoal)
                    }
                    financialStore.distributeIncome(shiftStore.totalIncome)
                    editingGoal = nil
                }
            }
            .onAppear {
                financialStore.distributeIncome(shiftStore.totalIncome)
            }
            .onChange(of: shiftStore.totalIncome) { _, newIncome in
                financialStore.distributeIncome(newIncome)
            }
        }
    }
}

struct FinanceStatPanel: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        GlassPanel {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(color)
                    Spacer()
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                    Text(value)
                        .font(.headline)
                        .foregroundStyle(.white)
                }
            }
            .padding()
        }
    }
}

struct GoalRow: View {
    let goal: FinancialGoal
    let onEdit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(goal.title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)
                Spacer()
                Text(goal.type.rawValue)
                    .font(.caption2.weight(.bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(goal.type.color.opacity(0.2))
                    .foregroundStyle(goal.type.color)
                    .clipShape(Capsule())
            }

            HStack {
                Text(String(format: "%.2f", goal.amountSaved))
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white)
                Text("из \(String(format: "%.2f", goal.amountNeeded))")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                Spacer()
                if goal.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                } else {
                    Text("\(Int(goal.progress * 100))%")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white.opacity(0.9))
                }
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [goal.type.color.opacity(0.7), goal.type.color],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(0, geometry.size.width * goal.progress), height: 8)
                }
            }
            .frame(height: 8)

            HStack {
                Text("Приоритет: \(goal.priority.title)")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.6))
                Spacer()
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(.white.opacity(0.22), lineWidth: 1)
                )
        )
        .swipeActions(edge: .trailing) {
            Button {
                onEdit()
            } label: {
                Label("Изменить", systemImage: "pencil")
            }
            .tint(.indigo)
        }
    }
}
