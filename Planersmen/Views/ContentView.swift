import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ShiftsView()
                .tabItem {
                    Label("Смены", systemImage: "calendar")
                }
                .tag(0)

            FinancesView()
                .tabItem {
                    Label("Финансы", systemImage: "banknote")
                }
                .tag(1)
        }
        .tint(.indigo)
    }
}

struct ShiftsView: View {
    @EnvironmentObject var store: ShiftStore
    @EnvironmentObject var financialStore: FinancialStore
    @State private var isPresentingEditor = false
    @State private var editingShift: Shift?

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }

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
                        Text("Планер смен")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        Text("Светлый и мощный взгляд на ваши смены")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    GlassPanel {
                        HStack(spacing: 12) {
                            Image(systemName: "sparkles")
                                .font(.title2)
                                .foregroundStyle(.white)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Сегодня в работе")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Text("\(store.items.count) смены в расписании")
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                            Spacer()
                            Circle()
                                .fill(Color(hex: "#8B5CF6"))
                                .frame(width: 10, height: 10)
                        }
                        .padding()
                    }
                    .padding(.horizontal)

                    if store.items.isEmpty {
                        GlassPanel {
                            VStack(spacing: 8) {
                                Image(systemName: "calendar.badge.plus")
                                    .font(.system(size: 44))
                                    .foregroundStyle(.secondary)
                                    .padding(.bottom, 4)
                                Text("Пока нет смен")
                                    .font(.title2.weight(.bold))
                                    .foregroundStyle(.white)
                                Text("Добавьте первую смену, чтобы начать планирование")
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
                            ForEach(store.items) { shift in
                                GlassRow(shift: shift, dateFormatter: dateFormatter) {
                                    editingShift = shift
                                    isPresentingEditor = true
                                }
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                            }
                            .onDelete(perform: store.delete(at:))
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
                        editingShift = nil
                        isPresentingEditor = true
                    } label: {
                        Label("Добавить", systemImage: "plus")
                    }
                    .foregroundStyle(.white)
                }
            }
            .sheet(isPresented: $isPresentingEditor) {
                ShiftFormView(shift: editingShift) { newShift in
                    if editingShift != nil {
                        store.update(newShift)
                    } else {
                        store.add(newShift)
                    }
                    financialStore.distributeIncome(store.totalIncome)
                    editingShift = nil
                }
            }
        }
    }

    private func color(for colorName: String) -> Color {
        ShiftColor(rawValue: colorName)?.accentColor ?? .blue
    }
}


private struct GlassRow: View {
    let shift: Shift
    let dateFormatter: DateFormatter
    let onEdit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(shift.title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)
                Spacer()
                Circle()
                    .fill(color(for: shift.colorName))
                    .frame(width: 12, height: 12)
            }

            Text("\(dateFormatter.string(from: shift.startDate)) — \(dateFormatter.string(from: shift.endDate))")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.85))

            if !shift.notes.isEmpty {
                Text(shift.notes)
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.7))
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

    private func color(for colorName: String) -> Color {
        ShiftColor(rawValue: colorName)?.accentColor ?? .blue
    }
}


#Preview {
    ContentView()
        .environmentObject(ShiftStore())
        .environmentObject(FinancialStore())
}
