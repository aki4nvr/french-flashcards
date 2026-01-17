import SwiftUI

struct AddWordView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var storage = StorageManager.shared

    @State private var french = ""
    @State private var english = ""
    @State private var selectedGender: WordGender?
    @State private var example = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""

    private var isValid: Bool {
        !french.trimmingCharacters(in: .whitespaces).isEmpty &&
        !english.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // French Word Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("French Word")
                        .font(.headline)

                    TextField("Enter French word", text: $french)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }

                // English Translation Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("English Translation")
                        .font(.headline)

                    TextField("Enter English translation", text: $english)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                }

                // Gender Selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("Gender (Optional)")
                        .font(.headline)

                    Picker("Gender", selection: $selectedGender) {
                        Text("None").tag(nil as WordGender?)
                        ForEach(WordGender.allCases, id: \.self) { gender in
                            Text(gender.displayText).tag(gender as WordGender?)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                // Example Sentence Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Example Sentence (Optional)")
                        .font(.headline)

                    TextField("Enter an example sentence", text: $example, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3...6)
                }

                Spacer(minLength: 20)

                // Save Button
                PrimaryButton(
                    title: "Save Word",
                    variant: .primary,
                    isDisabled: !isValid
                ) {
                    saveWord()
                }

                // Reset Button
                PrimaryButton(
                    title: "Clear Form",
                    variant: .secondary
                ) {
                    resetForm()
                }
            }
            .padding()
        }
        .navigationTitle("Add Word")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Success", isPresented: $showingAlert) {
            Button("Add Another") {
                resetForm()
            }
            Button("Done") {
                dismiss()
            }
        } message: {
            Text(alertMessage)
        }
    }

    private func saveWord() {
        let word = Word(
            french: french.trimmingCharacters(in: .whitespaces),
            english: english.trimmingCharacters(in: .whitespaces),
            gender: selectedGender,
            example: example.isEmpty ? nil : example.trimmingCharacters(in: .whitespaces)
        )

        storage.saveWord(word)
        alertMessage = "'\(word.french)' has been added to your vocabulary!"
        showingAlert = true
    }

    private func resetForm() {
        french = ""
        english = ""
        selectedGender = nil
        example = ""
    }
}

#Preview {
    NavigationStack {
        AddWordView()
    }
}
