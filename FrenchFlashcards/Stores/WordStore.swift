import Foundation
import SwiftUI

@MainActor
final class WordStore: ObservableObject {
    @Published private(set) var words: [WordEntry] = []

    private let storageKey = "FrenchFlashcards.words"

    init() {
        load()
    }

    func addWord(french: String, english: String, gender: String?, example: String?) {
        let trimmedFrench = french.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEnglish = english.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedFrench.isEmpty, !trimmedEnglish.isEmpty else { return }

        let word = WordEntry(
            french: trimmedFrench,
            english: trimmedEnglish,
            gender: gender?.isEmpty == true ? nil : gender,
            example: example?.isEmpty == true ? nil : example
        )
        words.insert(word, at: 0)
        persist()
    }

    func deleteWord(at offsets: IndexSet) {
        words.remove(atOffsets: offsets)
        persist()
    }

    func removeAll() {
        words.removeAll()
        persist()
    }

    func update(word: WordEntry) {
        guard let index = words.firstIndex(where: { $0.id == word.id }) else { return }
        words[index] = word
        persist()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        do {
            let decoded = try JSONDecoder().decode([WordEntry].self, from: data)
            words = decoded
        } catch {
            words = []
        }
    }

    private func persist() {
        do {
            let data = try JSONEncoder().encode(words)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            return
        }
    }
}
