import Foundation

struct Session: Identifiable, Codable {
    let id: UUID
    let date: Date
    let correct: Int
    let total: Int

    init(id: UUID = UUID(), date: Date = Date(), correct: Int, total: Int) {
        self.id = id
        self.date = date
        self.correct = correct
        self.total = total
    }

    var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(correct) / Double(total) * 100
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
