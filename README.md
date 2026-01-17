# French Flashcards (SwiftUI)

A minimal iOS French-English memorization app rewritten in SwiftUI.

## Features

- **Add Words**: Create custom French-English word pairs with optional gender and example sentences.
- **Word List**: Browse, search, and delete words.
- **Practice Mode**: Toggle between multiple-choice and typing questions.
- **Progress Tracking**: Session history and accuracy statistics.
- **Local Storage**: All data stored locally using `UserDefaults` with `Codable` models.

## Tech Stack

- Swift 5.9+
- SwiftUI
- Xcode 15+

## Getting Started

1. Open the project folder in Xcode.
2. Select an iOS simulator or device.
3. Build and run the app.

## Project Structure

```
FrenchFlashcards/
├── FrenchFlashcards/
│   ├── FrenchFlashcardsApp.swift
│   ├── Models/
│   │   ├── WordEntry.swift
│   │   └── PracticeSession.swift
│   ├── Stores/
│   │   ├── WordStore.swift
│   │   └── SessionStore.swift
│   └── Views/
│       ├── Components/
│       │   ├── CardView.swift
│       │   ├── PrimaryButton.swift
│       │   └── ProgressBarView.swift
│       └── Screens/
│           ├── AddWordView.swift
│           ├── HomeView.swift
│           ├── PracticeView.swift
│           └── WordListView.swift
```

## License

MIT
