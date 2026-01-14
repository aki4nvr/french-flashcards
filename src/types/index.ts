export type WordGender = 'm' | 'f' | undefined;

export interface Word {
  id: string;
  french: string;
  english: string;
  gender?: WordGender;
  example?: string;
  createdAt: number;
}

export interface Session {
  date: string;
  correct: number;
  total: number;
}

export type PracticeMode = 'multiple-choice' | 'typing';

export interface PracticeQuestion {
  type: PracticeMode;
  word: Word;
  options?: string[];
}
