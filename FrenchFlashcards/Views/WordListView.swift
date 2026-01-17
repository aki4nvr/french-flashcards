import SwiftUI

struct WordListView: View {
    @ObservedObject var storage = StorageManager.shared
    @State private var searchText = ""
    @State private var wordToDelete: Word?
    @State private var showingDeleteAlert = false

    private var filteredWords: [Word] {
        if searchText.isEmpty {
            return storage.vocabulary.sorted { $0.createdAt > $1.createdAt }
        }

        let query = searchText.lowercased()
        return storage.vocabulary.filter { word in
            word.french.lowercased().contains(query) ||
            word.english.lowercased().contains(query)
        }.sorted { $0.createdAt > $1.createdAt }
    }

    var body: some View {
        VStack {
            if storage.vocabulary.isEmpty {
                emptyState
            } else {
                wordList
            }
        }
        .navigationTitle("My Vocabulary")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Search words...")
        .alert("Delete Word", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                if let word = wordToDelete {
                    storage.deleteWord(word)
                }
            }
        } message: {
            if let word = wordToDelete {
                Text("Are you sure you want to delete '\(word.french)'?")
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text("No words yet")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Add some French words to get started!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    private var wordList: some View {
        List {
            ForEach(filteredWords) { word in
                WordRow(word: word)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            wordToDelete = word
                            showingDeleteAlert = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct WordRow: View {
    let word: Word

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(word.frenchWithArticle)
                    .font(.headline)

                Spacer()

                if let gender = word.gender {
                    Text(gender == .masculine ? "m" : "f")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(gender == .masculine ? Color.blue.opacity(0.2) : Color.pink.opacity(0.2))
                        .foregroundColor(gender == .masculine ? .blue : .pink)
                        .cornerRadius(4)
                }
            }

            Text(word.english)
                .font(.subheadline)
                .foregroundColor(.secondary)

            if let example = word.example {
                Text(example)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
                    .padding(.top, 2)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        WordListView()
    }
}
