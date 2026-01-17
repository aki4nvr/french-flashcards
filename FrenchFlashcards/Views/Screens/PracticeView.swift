import SwiftUI

struct PracticeView: View {
    @EnvironmentObject private var wordStore: WordStore
    @EnvironmentObject private var sessionStore: SessionStore

    @State private var mode: PracticeMode = .multipleChoice
    @State private var currentWord: WordEntry?
    @State private var choices: [String] = []
    @State private var userInput = ""
    @State private var feedback: String?
    @State private var isCorrect: Bool = false
    @State private var correctCount = 0
    @State private var totalCount = 0

    private let maxChoices = 4

    var body: some View {
        VStack(spacing: 20) {
            Picker("Mode", selection: $mode) {
                ForEach(PracticeMode.allCases) { mode in
                    Text(mode.title).tag(mode)
                }
            }
            .pickerStyle(.segmented)

            if let currentWord {
                CardView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Translate")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(currentWord.french)
                            .font(.title)
                            .fontWeight(.semibold)
                        if let example = currentWord.example, !example.isEmpty {
                            Text(example)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                if mode == .multipleChoice {
                    VStack(spacing: 12) {
                        ForEach(choices, id: \.self) { choice in
                            Button {
                                submitAnswer(choice)
                            } label: {
                                Text(choice)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(10)
                            }
                        }
                    }
                } else {
                    VStack(spacing: 12) {
                        TextField("Type the English translation", text: $userInput)
                            .textFieldStyle(.roundedBorder)
                        PrimaryButton(title: "Check Answer", systemImage: "checkmark") {
                            submitAnswer(userInput)
                        }
                        .disabled(userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }

                if let feedback {
                    Text(feedback)
                        .foregroundColor(isCorrect ? .green : .red)
                        .fontWeight(.semibold)
                }

                HStack {
                    Button("Next") {
                        nextQuestion()
                    }
                    .buttonStyle(.bordered)

                    Spacer()

                    Button("End Session") {
                        endSession()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(totalCount == 0)
                }
            } else {
                ContentUnavailableView("No Words", systemImage: "character.book.closed", description: Text("Add words before practicing."))
            }

            CardView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Session Progress")
                        .font(.headline)
                    Text("\(correctCount) correct out of \(totalCount)")
                        .foregroundColor(.secondary)
                    ProgressBarView(value: totalCount == 0 ? 0 : Double(correctCount) / Double(totalCount))
                        .frame(height: 12)
                }
            }
        }
        .padding()
        .navigationTitle("Practice")
        .onAppear {
            if currentWord == nil {
                nextQuestion()
            }
        }
    }

    private func nextQuestion() {
        guard let next = wordStore.words.randomElement() else {
            currentWord = nil
            return
        }
        currentWord = next
        userInput = ""
        feedback = nil
        isCorrect = false
        choices = makeChoices(for: next)
    }

    private func makeChoices(for word: WordEntry) -> [String] {
        let translations = wordStore.words.map { $0.english }.filter { !$0.isEmpty }
        var set = Set([word.english])
        while set.count < min(maxChoices, translations.count) {
            if let random = translations.randomElement() {
                set.insert(random)
            }
        }
        return Array(set).shuffled()
    }

    private func submitAnswer(_ answer: String) {
        guard let currentWord else { return }
        let normalizedAnswer = answer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let normalizedTarget = currentWord.english.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let correct = normalizedAnswer == normalizedTarget
        isCorrect = correct
        totalCount += 1
        if correct {
            correctCount += 1
            feedback = "Correct!"
        } else {
            feedback = "Not quite. Answer: \(currentWord.english)"
        }
    }

    private func endSession() {
        sessionStore.addSession(correct: correctCount, total: totalCount)
        correctCount = 0
        totalCount = 0
        feedback = nil
        userInput = ""
    }
}

private enum PracticeMode: String, CaseIterable, Identifiable {
    case multipleChoice
    case typing

    var id: String { rawValue }

    var title: String {
        switch self {
        case .multipleChoice:
            return "Multiple Choice"
        case .typing:
            return "Typing"
        }
    }
}

#Preview {
    NavigationStack {
        PracticeView()
            .environmentObject(WordStore())
            .environmentObject(SessionStore())
    }
}
