# French Flashcards

A minimal iOS French-English memorization app built with React Native + Expo.

## Features

- **Add Words**: Create custom French-English word pairs with optional gender and example sentences
- **Word List**: Browse and search your vocabulary with swipe-to-delete
- **Practice Mode**: Hybrid typing + multiple choice questions to test your knowledge
- **Progress Tracking**: Session history and accuracy statistics
- **Local Storage**: All data stored locally on device via AsyncStorage

## Tech Stack

- React Native 0.76
- Expo 52
- TypeScript
- React Navigation
- AsyncStorage

## Getting Started

### Prerequisites

- Node.js 18+
- Xcode (for iOS development)
- Expo Go app on iOS device or simulator

### Installation

```bash
cd french-flashcards
npm install
```

### Run on iOS Simulator

```bash
npx expo run:ios
```

### Run on Physical Device

1. Install Expo Go from App Store
2. Run `npx expo start`
3. Scan QR code with camera

## Project Structure

```
french-flashcards/
├── App.tsx                    # Main app with navigation
├── src/
│   ├── components/            # Reusable UI components
│   │   ├── Button.tsx
│   │   ├── Card.tsx
│   │   ├── Input.tsx
│   │   └── ProgressBar.tsx
│   ├── screens/               # App screens
│   │   ├── HomeScreen.tsx
│   │   ├── AddWordScreen.tsx
│   │   ├── WordListScreen.tsx
│   │   └── PracticeScreen.tsx
│   ├── utils/                 # Utilities
│   │   ├── storage.ts         # AsyncStorage operations
│   │   └── helpers.ts         # Helper functions
│   └── types/                 # TypeScript types
│       └── index.ts
└── app.json                   # Expo configuration
```

## Data Storage

Words and session history are stored locally using `@react-native-async-storage/async-storage`.

## License

MIT
