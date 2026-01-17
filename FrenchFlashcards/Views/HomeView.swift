import SwiftUI

struct HomeView: View {
    @ObservedObject var storage = StorageManager.shared
    @State private var showingPractice = false
    @State private var showingAddWord = false
    @State private var showingWordList = false

    private var canPractice: Bool {
        storage.wordCount >= 4
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("French Flashcards")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("Learn French vocabulary")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)

                    // Stats Section
                    VStack(spacing: 12) {
                        StatCard(
                            title: "Total Words",
                            value: "\(storage.wordCount)",
                            icon: "book.fill",
                            iconColor: .blue
                        )

                        StatCard(
                            title: "Practice Sessions",
                            value: "\(storage.totalSessions)",
                            icon: "chart.bar.fill",
                            iconColor: .green
                        )

                        if let lastSession = storage.lastSession {
                            StatCard(
                                title: "Last Session",
                                value: "\(lastSession.correct)/\(lastSession.total) (\(Int(lastSession.percentage))%)",
                                icon: "star.fill",
                                iconColor: .orange
                            )
                        }
                    }

                    // Action Buttons
                    VStack(spacing: 12) {
                        PrimaryButton(
                            title: canPractice ? "Start Practice" : "Add more words to practice",
                            variant: .primary,
                            isDisabled: !canPractice
                        ) {
                            showingPractice = true
                        }

                        PrimaryButton(
                            title: "Add New Word",
                            variant: .secondary
                        ) {
                            showingAddWord = true
                        }

                        PrimaryButton(
                            title: "View All Words",
                            variant: .secondary
                        ) {
                            showingWordList = true
                        }
                    }

                    if !canPractice && storage.wordCount > 0 {
                        Text("Add at least \(4 - storage.wordCount) more word\(4 - storage.wordCount == 1 ? "" : "s") to start practicing")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationDestination(isPresented: $showingPractice) {
                PracticeView()
            }
            .navigationDestination(isPresented: $showingAddWord) {
                AddWordView()
            }
            .navigationDestination(isPresented: $showingWordList) {
                WordListView()
            }
        }
    }
}

#Preview {
    HomeView()
}
