import SwiftUI
import SwiftData

@Observable
final class ShiftCalendarViewModel {
    var state: ViewState<[Shift]> = .loading
    var selectedView: String = "День"
    var showingAddShift = false
    let viewOptions = ["День", "Неделя", "Месяц"]

    func updateState(with shifts: [Shift]) {
        if shifts.isEmpty {
            state = .empty
        } else {
            state = .success(shifts)
        }
    }
}

struct ShiftCalendarView: View {
    @Environment(\.md3ColorScheme) var md3
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Shift.date, order: .forward) private var shifts: [Shift]

    @State private var viewModel = ShiftCalendarViewModel()

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                MD3TopAppBar(title: "Расписание") {
                    // Action for "Сегодня" (Today) button
                    print("Jump to today")
                }

                MD3SegmentedButton(options: viewModel.viewOptions, selection: $viewModel.selectedView)
                    .padding(.vertical, 16)
                    .background(md3.surface)

                ScrollView {
                    LazyVStack(spacing: 12) {
                        switch viewModel.state {
                        case .loading:
                            ProgressView()
                                .padding(.top, 60)
                        case .empty:
                            VStack(spacing: 16) {
                                Image(systemName: "calendar.badge.exclamationmark")
                                    .font(.system(size: 48))
                                    .foregroundColor(md3.outline)
                                Text("Нет смен")
                                    .font(.headline)
                                    .foregroundColor(md3.onSurfaceVariant)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                        case .error(let message):
                            Text(message)
                                .foregroundColor(md3.error)
                                .padding(.top, 60)
                        case .success(let data):
                            ForEach(data) { shift in
                                MD3ShiftCard(shift: shift) {
                                    // Handle shift tap (e.g., edit or details)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 80) // Space for FAB
                }
                .background(md3.background)
            }

            MD3FloatingActionButton(icon: "plus") {
                viewModel.showingAddShift = true
            }
            .padding(16)
        }
        .md3Theme()
        .onChange(of: shifts, initial: true) { _, newShifts in
            viewModel.updateState(with: newShifts)
        }
        .sheet(isPresented: $viewModel.showingAddShift) {
            // Simplified sheet for adding shift for demonstration
            NavigationView {
                VStack {
                    Text("Добавление смены")
                        .font(.title)
                        .padding()
                    Button("Добавить тестовую смену") {
                        let newShift = Shift(
                            date: Date(),
                            type: .day,
                            startTime: Date(),
                            endTime: Date().addingTimeInterval(8 * 3600),
                            notes: "Тестовая дневная смена"
                        )
                        modelContext.insert(newShift)
                        viewModel.showingAddShift = false
                    }
                    .padding()
                    .background(md3.primaryContainer)
                    .foregroundColor(md3.onPrimaryContainer)
                    .clipShape(Capsule())
                }
                .navigationTitle("Новая смена")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
