import Foundation
import SwiftUI

@MainActor
final class SessionStore: ObservableObject {
    @Published private(set) var sessions: [PracticeSession] = []

    private let storageKey = "FrenchFlashcards.sessions"

    init() {
        load()
    }

    func addSession(correct: Int, total: Int) {
        guard total > 0 else { return }
        let session = PracticeSession(correct: correct, total: total)
        sessions.insert(session, at: 0)
        persist()
    }

    func clearSessions() {
        sessions.removeAll()
        persist()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        do {
            let decoded = try JSONDecoder().decode([PracticeSession].self, from: data)
            sessions = decoded
        } catch {
            sessions = []
        }
    }

    private func persist() {
        do {
            let data = try JSONEncoder().encode(sessions)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            return
        }
    }
}
