import Foundation

struct PracticeHelper {
    /// Generate distractor options for multiple choice questions
    static func generateDistractors(for word: Word, from allWords: [Word], count: Int = 3) -> [String] {
        let otherWords = allWords.filter { $0.id != word.id }
        let shuffled = otherWords.shuffled()
        let distractors = Array(shuffled.prefix(count)).map { $0.english }
        return distractors
    }

    /// Generate a set of practice questions
    static func generateQuestions(from words: [Word], count: Int = 10) -> [PracticeQuestion] {
        let selectedWords = Array(words.shuffled().prefix(count))
        var questions: [PracticeQuestion] = []

        for (index, word) in selectedWords.enumerated() {
            // Alternate between multiple choice and typing
            let mode: PracticeMode = index % 2 == 0 ? .multipleChoice : .typing

            var options: [String]? = nil
            if mode == .multipleChoice {
                let distractors = generateDistractors(for: word, from: words)
                options = (distractors + [word.english]).shuffled()
            }

            let question = PracticeQuestion(mode: mode, word: word, options: options)
            questions.append(question)
        }

        return questions
    }

    /// Normalize a string for answer comparison
    static func normalizeString(_ str: String) -> String {
        return str.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Check if user answer matches the correct answer
    static func checkAnswer(userAnswer: String, correctAnswer: String) -> Bool {
        return normalizeString(userAnswer) == normalizeString(correctAnswer)
    }
}
