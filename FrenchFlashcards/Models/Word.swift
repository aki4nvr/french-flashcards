import Foundation

enum WordGender: String, Codable, CaseIterable {
    case masculine = "m"
    case feminine = "f"

    var displayText: String {
        switch self {
        case .masculine: return "Masculine (le)"
        case .feminine: return "Feminine (la)"
        }
    }

    var article: String {
        switch self {
        case .masculine: return "le"
        case .feminine: return "la"
        }
    }
}

struct Word: Identifiable, Codable, Equatable {
    let id: UUID
    var french: String
    var english: String
    var gender: WordGender?
    var example: String?
    let createdAt: Date

    init(id: UUID = UUID(), french: String, english: String, gender: WordGender? = nil, example: String? = nil, createdAt: Date = Date()) {
        self.id = id
        self.french = french
        self.english = english
        self.gender = gender
        self.example = example
        self.createdAt = createdAt
    }

    var frenchWithArticle: String {
        if let gender = gender {
            return "\(gender.article) \(french)"
        }
        return french
    }
}
