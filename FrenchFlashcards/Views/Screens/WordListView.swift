import SwiftUI

struct WordListView: View {
    @EnvironmentObject private var wordStore: WordStore
    @State private var searchText = ""

    private var filteredWords: [WordEntry] {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return wordStore.words
        }
        return wordStore.words.filter { word in
            word.french.localizedCaseInsensitiveContains(searchText)
            || word.english.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        List {
            if filteredWords.isEmpty {
                ContentUnavailableView("No Words", systemImage: "character.book.closed", description: Text("Add your first French-English pair to get started."))
            } else {
                ForEach(filteredWords) { word in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(word.french)
                                .font(.headline)
                            if let gender = word.gender, !gender.isEmpty {
                                Text(gender)
                                    .font(.caption)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        Text(word.english)
                            .foregroundColor(.secondary)
                        if let example = word.example, !example.isEmpty {
                            Text(example)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 6)
                }
                .onDelete(perform: wordStore.deleteWord)
            }
        }
        .navigationTitle("Your Words")
        .searchable(text: $searchText, prompt: "Search French or English")
        .toolbar {
            EditButton()
        }
    }
}

#Preview {
    NavigationStack {
        WordListView()
            .environmentObject(WordStore())
    }
}
