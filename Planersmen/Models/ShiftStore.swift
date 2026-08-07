import Foundation
import SwiftData
import SwiftUI

enum ShiftType: String, Codable, CaseIterable, Identifiable {
    case day = "Дневная смена"
    case night = "Ночная смена"
    case overtime = "Переработка"
    case timeOff = "Отгул/Отпуск"

    var id: String { rawValue }
}

@Model
final class Shift {
    var id: UUID
    var date: Date
    var type: ShiftType
    var startTime: Date
    var endTime: Date
    var rate: Double
    var notes: String

    init(
        id: UUID = UUID(),
        date: Date,
        type: ShiftType,
        startTime: Date,
        endTime: Date,
        rate: Double = 0.0,
        notes: String = ""
    ) {
        self.id = id
        self.date = date
        self.type = type
        self.startTime = startTime
        self.endTime = endTime
        self.rate = rate
        self.notes = notes
    }
}
