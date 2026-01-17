import SwiftUI

struct PracticeView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var storage = StorageManager.shared

    @State private var questions: [PracticeQuestion] = []
    @State private var currentIndex = 0
    @State private var score = 0
    @State private var typedAnswer = ""
    @State private var selectedAnswer: String?
    @State private var showingResult = false
    @State private var isCorrect = false
    @State private var sessionComplete = false

    var sessionSize: Int = 10

    private var currentQuestion: PracticeQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    private var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentIndex) / Double(questions.count)
    }

    var body: some View {
        VStack(spacing: 20) {
            if sessionComplete {
                resultsView
            } else if let question = currentQuestion {
                questionView(question)
            } else {
                loadingView
            }
        }
        .padding()
        .navigationTitle("Practice")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(sessionComplete)
        .toolbar {
            if sessionComplete {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            startPractice()
        }
    }

    // MARK: - Views

    private var loadingView: some View {
        VStack {
            ProgressView()
            Text("Loading questions...")
                .foregroundColor(.secondary)
        }
    }

    private func questionView(_ question: PracticeQuestion) -> some View {
        VStack(spacing: 20) {
            // Progress
            VStack(spacing: 8) {
                ProgressBarView(progress: progress, foregroundColor: .blue)
                Text("Question \(currentIndex + 1) of \(questions.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            // Score
            HStack {
                Spacer()
                Text("Score: \(score)/\(currentIndex)")
                    .font(.headline)
                    .foregroundColor(.green)
            }

            Spacer()

            // Question Card
            CardView {
                VStack(spacing: 16) {
                    Text("What is the English translation of:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(question.word.frenchWithArticle)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    if showingResult, let example = question.word.example {
                        Text("Example: \(example)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .italic()
                            .padding(.top, 8)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }

            Spacer()

            // Answer Section
            if question.mode == .multipleChoice {
                multipleChoiceView(question)
            } else {
                typingView(question)
            }

            Spacer()
        }
    }

    private func multipleChoiceView(_ question: PracticeQuestion) -> some View {
        VStack(spacing: 12) {
            ForEach(question.options ?? [], id: \.self) { option in
                Button {
                    if !showingResult {
                        selectAnswer(option, correctAnswer: question.word.english)
                    }
                } label: {
                    HStack {
                        Text(option)
                            .fontWeight(.medium)
                        Spacer()

                        if showingResult {
                            if option == question.word.english {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else if option == selectedAnswer && !isCorrect {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding()
                    .background(optionBackgroundColor(for: option, correctAnswer: question.word.english))
                    .foregroundColor(optionForegroundColor(for: option, correctAnswer: question.word.english))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(optionBorderColor(for: option, correctAnswer: question.word.english), lineWidth: 2)
                    )
                }
                .disabled(showingResult)
            }

            if showingResult {
                nextButton
            }
        }
    }

    private func typingView(_ question: PracticeQuestion) -> some View {
        VStack(spacing: 16) {
            TextField("Type the English translation", text: $typedAnswer)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disabled(showingResult)

            if showingResult {
                HStack {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(isCorrect ? .green : .red)
                    Text(isCorrect ? "Correct!" : "Incorrect. The answer was: \(question.word.english)")
                        .fontWeight(.medium)
                }
                .padding()
                .background(isCorrect ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                .cornerRadius(8)

                nextButton
            } else {
                PrimaryButton(
                    title: "Submit",
                    variant: .primary,
                    isDisabled: typedAnswer.trimmingCharacters(in: .whitespaces).isEmpty
                ) {
                    checkTypedAnswer(correctAnswer: question.word.english)
                }
            }
        }
    }

    private var nextButton: some View {
        PrimaryButton(title: currentIndex < questions.count - 1 ? "Next Question" : "See Results") {
            moveToNext()
        }
    }

    private var resultsView: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: score >= questions.count / 2 ? "star.fill" : "star")
                .font(.system(size: 80))
                .foregroundColor(.yellow)

            Text("Practice Complete!")
                .font(.title)
                .fontWeight(.bold)

            VStack(spacing: 8) {
                Text("Your Score")
                    .font(.headline)
                    .foregroundColor(.secondary)

                Text("\(score) / \(questions.count)")
                    .font(.system(size: 48, weight: .bold))

                Text("\(Int(Double(score) / Double(questions.count) * 100))%")
                    .font(.title2)
                    .foregroundColor(score >= questions.count / 2 ? .green : .orange)
            }

            Spacer()

            PrimaryButton(title: "Practice Again") {
                resetPractice()
            }

            PrimaryButton(title: "Done", variant: .secondary) {
                dismiss()
            }
        }
    }

    // MARK: - Helper Functions

    private func optionBackgroundColor(for option: String, correctAnswer: String) -> Color {
        guard showingResult else {
            return selectedAnswer == option ? Color.blue.opacity(0.1) : Color(.systemGray6)
        }

        if option == correctAnswer {
            return Color.green.opacity(0.2)
        } else if option == selectedAnswer {
            return Color.red.opacity(0.2)
        }
        return Color(.systemGray6)
    }

    private func optionForegroundColor(for option: String, correctAnswer: String) -> Color {
        guard showingResult else { return .primary }

        if option == correctAnswer {
            return .green
        } else if option == selectedAnswer {
            return .red
        }
        return .primary
    }

    private func optionBorderColor(for option: String, correctAnswer: String) -> Color {
        guard showingResult else {
            return selectedAnswer == option ? .blue : .clear
        }

        if option == correctAnswer {
            return .green
        } else if option == selectedAnswer {
            return .red
        }
        return .clear
    }

    // MARK: - Actions

    private func startPractice() {
        let count = min(sessionSize, storage.vocabulary.count)
        questions = PracticeHelper.generateQuestions(from: storage.vocabulary, count: count)
    }

    private func selectAnswer(_ answer: String, correctAnswer: String) {
        selectedAnswer = answer
        isCorrect = PracticeHelper.checkAnswer(userAnswer: answer, correctAnswer: correctAnswer)
        if isCorrect {
            score += 1
        }
        showingResult = true
    }

    private func checkTypedAnswer(correctAnswer: String) {
        isCorrect = PracticeHelper.checkAnswer(userAnswer: typedAnswer, correctAnswer: correctAnswer)
        if isCorrect {
            score += 1
        }
        showingResult = true
    }

    private func moveToNext() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
            resetQuestion()
        } else {
            // Save session
            let session = Session(correct: score, total: questions.count)
            storage.saveSession(session)
            sessionComplete = true
        }
    }

    private func resetQuestion() {
        selectedAnswer = nil
        typedAnswer = ""
        showingResult = false
        isCorrect = false
    }

    private func resetPractice() {
        currentIndex = 0
        score = 0
        sessionComplete = false
        resetQuestion()
        startPractice()
    }
}

#Preview {
    NavigationStack {
        PracticeView()
    }
}
