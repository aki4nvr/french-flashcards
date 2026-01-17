import Foundation

struct WordEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var french: String
    var english: String
    var gender: String?
    var example: String?
    let createdAt: Date

    init(id: UUID = UUID(), french: String, english: String, gender: String? = nil, example: String? = nil, createdAt: Date = Date()) {
        self.id = id
        self.french = french
        self.english = english
        self.gender = gender
        self.example = example
        self.createdAt = createdAt
    }
}
