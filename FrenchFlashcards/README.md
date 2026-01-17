# French Flashcards - Native iOS App

A native iOS application for learning French vocabulary, built with SwiftUI.

## Features

- **Add Vocabulary**: Create flashcards with French words, English translations, optional gender markers, and example sentences
- **Word List**: Browse, search, and manage your vocabulary with swipe-to-delete
- **Practice Mode**: Quiz yourself with alternating multiple-choice and typing exercises
- **Progress Tracking**: Track your learning sessions and scores
- **Offline-First**: All data stored locally using UserDefaults

## Requirements

- Xcode 15.0+
- iOS 17.0+
- Swift 5.0+

## Project Structure

```
FrenchFlashcards/
├── FrenchFlashcardsApp.swift      # App entry point
├── Models/
│   ├── Word.swift                 # Word data model with gender support
│   ├── Session.swift              # Practice session tracking
│   └── PracticeQuestion.swift     # Question types for practice
├── Views/
│   ├── HomeView.swift             # Dashboard with stats
│   ├── AddWordView.swift          # Form to add new words
│   ├── WordListView.swift         # Searchable word list
│   └── PracticeView.swift         # Quiz interface
├── Components/
│   ├── CardView.swift             # Reusable card container
│   ├── ProgressBarView.swift      # Visual progress indicator
│   ├── PrimaryButton.swift        # Button with variants
│   └── StatCard.swift             # Statistics display card
├── Services/
│   ├── StorageManager.swift       # UserDefaults persistence
│   └── PracticeHelper.swift       # Quiz logic utilities
└── Assets.xcassets/               # App icons and colors
```

## Getting Started

1. Open `FrenchFlashcards.xcodeproj` in Xcode
2. Select your target device or simulator
3. Press `Cmd + R` to build and run

## Architecture

- **SwiftUI**: Declarative UI framework for all views
- **MVVM-lite**: Views observe the shared StorageManager
- **UserDefaults**: Simple local persistence with Codable models
- **NavigationStack**: iOS 16+ navigation with programmatic destinations

## Data Models

### Word
```swift
struct Word: Identifiable, Codable {
    let id: UUID
    var french: String
    var english: String
    var gender: WordGender?  // .masculine or .feminine
    var example: String?
    let createdAt: Date
}
```

### Session
```swift
struct Session: Identifiable, Codable {
    let id: UUID
    let date: Date
    let correct: Int
    let total: Int
}
```

## Key Features

### Practice Mode
- Minimum 4 words required to start practice
- Alternates between multiple-choice and typing questions
- Visual feedback for correct/incorrect answers
- Session results saved automatically

### Gender Support
- Optional masculine (le) / feminine (la) markers
- Displayed with articles in practice questions

## License

MIT License
