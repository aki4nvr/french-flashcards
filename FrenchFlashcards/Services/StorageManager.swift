import Foundation

class StorageManager: ObservableObject {
    static let shared = StorageManager()

    private let vocabularyKey = "vocabulary"
    private let sessionsKey = "sessions"

    @Published var vocabulary: [Word] = []
    @Published var sessions: [Session] = []

    private init() {
        loadVocabulary()
        loadSessions()
    }

    // MARK: - Vocabulary Operations

    func loadVocabulary() {
        guard let data = UserDefaults.standard.data(forKey: vocabularyKey) else {
            vocabulary = []
            return
        }

        do {
            vocabulary = try JSONDecoder().decode([Word].self, from: data)
        } catch {
            print("Error loading vocabulary: \(error)")
            vocabulary = []
        }
    }

    func saveWord(_ word: Word) {
        vocabulary.append(word)
        persistVocabulary()
    }

    func updateWord(_ word: Word) {
        if let index = vocabulary.firstIndex(where: { $0.id == word.id }) {
            vocabulary[index] = word
            persistVocabulary()
        }
    }

    func deleteWord(_ word: Word) {
        vocabulary.removeAll { $0.id == word.id }
        persistVocabulary()
    }

    func deleteWord(at offsets: IndexSet) {
        vocabulary.remove(atOffsets: offsets)
        persistVocabulary()
    }

    private func persistVocabulary() {
        do {
            let data = try JSONEncoder().encode(vocabulary)
            UserDefaults.standard.set(data, forKey: vocabularyKey)
        } catch {
            print("Error saving vocabulary: \(error)")
        }
    }

    // MARK: - Session Operations

    func loadSessions() {
        guard let data = UserDefaults.standard.data(forKey: sessionsKey) else {
            sessions = []
            return
        }

        do {
            sessions = try JSONDecoder().decode([Session].self, from: data)
        } catch {
            print("Error loading sessions: \(error)")
            sessions = []
        }
    }

    func saveSession(_ session: Session) {
        sessions.append(session)
        persistSessions()
    }

    private func persistSessions() {
        do {
            let data = try JSONEncoder().encode(sessions)
            UserDefaults.standard.set(data, forKey: sessionsKey)
        } catch {
            print("Error saving sessions: \(error)")
        }
    }

    // MARK: - Stats

    var wordCount: Int {
        vocabulary.count
    }

    var totalSessions: Int {
        sessions.count
    }

    var lastSession: Session? {
        sessions.last
    }

    // MARK: - Clear Data

    func clearAllData() {
        vocabulary = []
        sessions = []
        UserDefaults.standard.removeObject(forKey: vocabularyKey)
        UserDefaults.standard.removeObject(forKey: sessionsKey)
    }
}
