import SwiftUI

struct AddWordView: View {
    @EnvironmentObject private var wordStore: WordStore
    @State private var french = ""
    @State private var english = ""
    @State private var gender = ""
    @State private var example = ""
    @State private var showConfirmation = false

    var body: some View {
        Form {
            Section("Word Pair") {
                TextField("French word", text: $french)
                TextField("English translation", text: $english)
            }

            Section("Optional Details") {
                TextField("Gender (le / la)", text: $gender)
                TextField("Example sentence", text: $example, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
            }

            Section {
                PrimaryButton(title: "Save Word", systemImage: "checkmark") {
                    wordStore.addWord(french: french, english: english, gender: gender, example: example)
                    french = ""
                    english = ""
                    gender = ""
                    example = ""
                    showConfirmation = true
                }
                .disabled(french.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                          || english.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .navigationTitle("Add Word")
        .alert("Saved", isPresented: $showConfirmation) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your word has been saved to the list.")
        }
    }
}

#Preview {
    NavigationStack {
        AddWordView()
            .environmentObject(WordStore())
    }
}
