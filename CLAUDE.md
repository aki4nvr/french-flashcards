# CLAUDE.md - AI Assistant Guide for French Flashcards

## Project Overview

This is a **React Native + Expo** mobile application for French-English vocabulary learning. The app allows users to create flashcards, practice with multiple-choice and typing exercises, and track their learning progress.

**Tech Stack:**
- React Native 0.81.5 with Expo ~54.0.31
- TypeScript 5.9.2 (strict mode enabled)
- React Navigation 7.x (Native Stack)
- AsyncStorage for local data persistence
- No backend - fully offline/local app

## Codebase Structure

```
french-flashcards/
├── App.tsx                    # Main entry - React Navigation setup
├── index.ts                   # Expo entry point
├── package.json               # Dependencies and npm scripts
├── tsconfig.json              # TypeScript config (extends expo/tsconfig.base)
├── app.json                   # Expo configuration
├── assets/                    # App icons and splash screen
└── src/
    ├── components/            # Reusable UI components
    │   ├── Button.tsx         # Variants: primary, secondary, danger
    │   ├── Card.tsx           # Container with shadow/rounded corners
    │   ├── Input.tsx          # Text input with label support
    │   ├── ProgressBar.tsx    # Visual progress indicator
    │   └── index.ts           # Barrel export
    ├── screens/               # App screens
    │   ├── HomeScreen.tsx     # Dashboard with stats and navigation
    │   ├── AddWordScreen.tsx  # Form to add vocabulary
    │   ├── WordListScreen.tsx # List view with search and delete
    │   └── PracticeScreen.tsx # Quiz with multiple-choice and typing
    ├── utils/
    │   ├── storage.ts         # AsyncStorage CRUD operations
    │   └── helpers.ts         # Practice logic and string utilities
    └── types/
        └── index.ts           # TypeScript interfaces
```

## Key Type Definitions

```typescript
// Core types in src/types/index.ts
interface Word {
  id: string;
  french: string;
  english: string;
  gender?: 'm' | 'f';
  example?: string;
  createdAt: string;
}

interface Session {
  date: string;
  correct: number;
  total: number;
}

type PracticeMode = 'multiple-choice' | 'typing';
```

## Development Workflow

### Running the App

```bash
npm install          # Install dependencies
npm start            # Start Expo dev server
npm run ios          # Run on iOS simulator
npm run android      # Run on Android emulator
npm run web          # Run web version
```

### Navigation Structure

```
Home (no header)
├── AddWord     → Form to create new flashcards
├── WordList    → View/search/delete vocabulary
└── Practice    → Quiz session (accepts sessionSize param)
```

### Data Storage

Local AsyncStorage with two keys:
- `@vocabulary` - Array of Word objects
- `@sessions` - Array of Session practice history

All storage operations are in `src/utils/storage.ts`:
- `getVocabulary()`, `saveWord()`, `deleteWord()`, `updateWord()`
- `getSessions()`, `saveSession()`, `clearAllData()`

## Code Conventions

### Component Patterns

1. **Functional components with TypeScript** - All components use React.FC or explicit prop types
2. **Inline StyleSheet** - Styles defined at bottom of each file using `StyleSheet.create()`
3. **Barrel exports** - Use `index.ts` files for clean imports
4. **Hooks for navigation** - `useNavigation()` and `useRoute()` from React Navigation

### Styling Guidelines

- **Color scheme:** Light theme with accent colors (green #28a745 for success, red #ff3b30 for errors)
- **Spacing:** 8px, 12px, 16px, 20px, 24px increments
- **Border radius:** 8-12px for rounded corners
- **Font weights:** 600-700 for emphasis

### Error Handling

- All async storage operations wrapped in try-catch
- Console.error for logging failures
- Alert dialogs for user-facing errors
- Fallback to empty arrays on storage read errors

### Import Order

1. React and React Native imports
2. Third-party libraries (navigation, storage, uuid)
3. Local components (from `../components`)
4. Local utilities and types
5. Type imports last

## Testing

**No testing framework is currently set up.** Consider adding:
- Jest for unit tests
- React Native Testing Library for component tests
- Detox for E2E tests

## Common Tasks

### Adding a New Screen

1. Create screen file in `src/screens/`
2. Add to navigation stack in `App.tsx`
3. Add TypeScript types for route params if needed

### Adding a New Component

1. Create component in `src/components/`
2. Export from `src/components/index.ts`
3. Use StyleSheet.create() for styles

### Modifying Data Schema

1. Update types in `src/types/index.ts`
2. Update storage functions in `src/utils/storage.ts`
3. Consider migration for existing data

## Things to Avoid

- **Don't add backend dependencies** - This is intentionally an offline-first app
- **Don't use Redux/MobX** - Local useState is sufficient for current scope
- **Don't change navigation structure** - Users expect current flow
- **Don't remove AsyncStorage** - All user data depends on it
- **Avoid adding heavy dependencies** - Keep bundle size minimal for mobile

## Build Configuration

### Expo Settings (app.json)

- Bundle ID: `com.yourname.frenchflashcards`
- Orientation: Portrait only
- New Architecture: Enabled
- Platform support: iOS, Android, Web

### TypeScript Settings

- Strict mode enabled
- Extends expo/tsconfig.base
- Target: ES modules

## Git Workflow

- Main development on feature branches
- Commit messages should be descriptive
- Recent commits focused on TypeScript fixes and build simplification
