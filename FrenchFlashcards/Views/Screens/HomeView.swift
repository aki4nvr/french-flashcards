import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var wordStore: WordStore
    @EnvironmentObject private var sessionStore: SessionStore

    private var totalWordsText: String {
        "\(wordStore.words.count) word\(wordStore.words.count == 1 ? "" : "s")"
    }

    private var averageAccuracy: Double {
        let totals = sessionStore.sessions.reduce(into: (correct: 0, total: 0)) { result, session in
            result.correct += session.correct
            result.total += session.total
        }
        guard totals.total > 0 else { return 0 }
        return Double(totals.correct) / Double(totals.total)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                CardView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Vocabulary")
                            .font(.headline)
                        Text(totalWordsText)
                            .font(.title2)
                        ProgressBarView(value: min(1, Double(wordStore.words.count) / 50))
                            .frame(height: 12)
                        Text("Aim for 50 words to build momentum.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                CardView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Practice Accuracy")
                            .font(.headline)
                        Text("\(Int(averageAccuracy * 100))% overall")
                            .font(.title2)
                        ProgressBarView(value: averageAccuracy)
                            .frame(height: 12)
                        Text("Keep practicing to improve your score.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Sessions")
                        .font(.headline)

                    if sessionStore.sessions.isEmpty {
                        Text("No practice sessions yet. Start a session from the Practice tab.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(sessionStore.sessions.prefix(5)) { session in
                            CardView {
                                HStack {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(session.date, style: .date)
                                            .font(.subheadline)
                                        Text("\(session.correct)/\(session.total) correct")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text("\(Int(session.accuracy * 100))%")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("French Flashcards")
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(WordStore())
            .environmentObject(SessionStore())
    }
}
