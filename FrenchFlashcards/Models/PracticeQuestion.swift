import Foundation

enum PracticeMode: String, CaseIterable {
    case multipleChoice = "multiple-choice"
    case typing = "typing"

    var displayName: String {
        switch self {
        case .multipleChoice: return "Multiple Choice"
        case .typing: return "Typing"
        }
    }
}

struct PracticeQuestion: Identifiable {
    let id: UUID
    let mode: PracticeMode
    let word: Word
    let options: [String]?

    init(id: UUID = UUID(), mode: PracticeMode, word: Word, options: [String]? = nil) {
        self.id = id
        self.mode = mode
        self.word = word
        self.options = options
    }
}
