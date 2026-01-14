import { Word } from '../types';

export const generateDistractors = (correctWord: Word, allWords: Word[]): string[] => {
  const distractors = allWords
    .filter(w => w.id !== correctWord.id)
    .map(w => w.english);
  
  const shuffled = distractors.sort(() => Math.random() - 0.5);
  return shuffled.slice(0, 3);
};

export const generateQuestions = (words: Word[], count: number): Word[] => {
  if (words.length === 0) return [];
  
  const shuffled = [...words].sort(() => Math.random() - 0.5);
  return shuffled.slice(0, Math.min(count, shuffled.length));
};

export const normalizeString = (str: string): string => {
  return str.toLowerCase().trim();
};

export const checkAnswer = (userAnswer: string, correctAnswer: string): boolean => {
  return normalizeString(userAnswer) === normalizeString(correctAnswer);
};
