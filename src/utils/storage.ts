import AsyncStorage from '@react-native-async-storage/async-storage';
import { Word, Session } from '../types';

const VOCABULARY_KEY = '@vocabulary';
const SESSIONS_KEY = '@sessions';

export const getVocabulary = async (): Promise<Word[]> => {
  try {
    const data = await AsyncStorage.getItem(VOCABULARY_KEY);
    return data ? JSON.parse(data) : [];
  } catch (error) {
    console.error('Error getting vocabulary:', error);
    return [];
  }
};

export const saveWord = async (word: Word): Promise<Word[]> => {
  try {
    const vocabulary = await getVocabulary();
    const updated = [...vocabulary, word];
    await AsyncStorage.setItem(VOCABULARY_KEY, JSON.stringify(updated));
    return updated;
  } catch (error) {
    console.error('Error saving word:', error);
    return [];
  }
};

export const deleteWord = async (id: string): Promise<Word[]> => {
  try {
    const vocabulary = await getVocabulary();
    const updated = vocabulary.filter(w => w.id !== id);
    await AsyncStorage.setItem(VOCABULARY_KEY, JSON.stringify(updated));
    return updated;
  } catch (error) {
    console.error('Error deleting word:', error);
    return [];
  }
};

export const updateWord = async (updatedWord: Word): Promise<Word[]> => {
  try {
    const vocabulary = await getVocabulary();
    const updated = vocabulary.map(w => w.id === updatedWord.id ? updatedWord : w);
    await AsyncStorage.setItem(VOCABULARY_KEY, JSON.stringify(updated));
    return updated;
  } catch (error) {
    console.error('Error updating word:', error);
    return [];
  }
};

export const getSessions = async (): Promise<Session[]> => {
  try {
    const data = await AsyncStorage.getItem(SESSIONS_KEY);
    return data ? JSON.parse(data) : [];
  } catch (error) {
    console.error('Error getting sessions:', error);
    return [];
  }
};

export const saveSession = async (session: Session): Promise<void> => {
  try {
    const sessions = await getSessions();
    const updated = [...sessions, session];
    await AsyncStorage.setItem(SESSIONS_KEY, JSON.stringify(updated));
  } catch (error) {
    console.error('Error saving session:', error);
  }
};

export const clearAllData = async (): Promise<void> => {
  try {
    await AsyncStorage.multiRemove([VOCABULARY_KEY, SESSIONS_KEY]);
  } catch (error) {
    console.error('Error clearing data:', error);
  }
};
