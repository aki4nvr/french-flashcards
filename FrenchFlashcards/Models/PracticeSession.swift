import Foundation

struct PracticeSession: Identifiable, Codable {
    let id: UUID
    let date: Date
    let correct: Int
    let total: Int

    var accuracy: Double {
        guard total > 0 else { return 0 }
        return Double(correct) / Double(total)
    }

    init(id: UUID = UUID(), date: Date = Date(), correct: Int, total: Int) {
        self.id = id
        self.date = date
        self.correct = correct
        self.total = total
    }
}
