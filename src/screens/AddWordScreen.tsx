import React, { useState } from 'react';
import { View, StyleSheet, Alert, ScrollView, KeyboardAvoidingView, Platform, Text, TouchableOpacity } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { v4 as uuidv4 } from 'uuid';
import { Button } from '../components/Button';
import { Input } from '../components/Input';
import { Card } from '../components/Card';
import { saveWord } from '../utils/storage';
import { Word } from '../types';

export const AddWordScreen: React.FC = () => {
  const navigation = useNavigation();
  const [french, setFrench] = useState('');
  const [english, setEnglish] = useState('');
  const [gender, setGender] = useState<'m' | 'f' | undefined>(undefined);
  const [example, setExample] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSave = async () => {
    if (!french.trim() || !english.trim()) {
      Alert.alert('Error', 'Please fill in both French and English words.');
      return;
    }

    setLoading(true);
    const newWord: Word = {
      id: uuidv4(),
      french: french.trim(),
      english: english.trim(),
      gender,
      example: example.trim() || undefined,
      createdAt: Date.now(),
    };

    await saveWord(newWord);
    setLoading(false);

    Alert.alert('Success', 'Word saved!', [
      { text: 'Add Another', onPress: () => resetForm() },
      { text: 'Done', onPress: () => navigation.goBack() },
    ]);
  };

  const resetForm = () => {
    setFrench('');
    setEnglish('');
    setGender(undefined);
    setExample('');
  };

  return (
    <KeyboardAvoidingView
      style={styles.container}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      <ScrollView contentContainerStyle={styles.scrollContent}>
        <View style={styles.content}>
          <Text style={styles.title}>Add New Word</Text>

          <Card>
            <Input
              label="French Word"
              placeholder="Enter French word"
              value={french}
              onChangeText={setFrench}
            />
            <Input
              label="English Translation"
              placeholder="Enter English translation"
              value={english}
              onChangeText={setEnglish}
            />

            <Text style={styles.label}>Gender (optional)</Text>
            <View style={styles.genderContainer}>
              {(['m', 'f', undefined] as const).map((g) => (
                <TouchableOpacity
                  key={g ?? 'none'}
                  style={[
                    styles.genderButton,
                    gender === g && styles.genderButtonActive,
                  ]}
                  onPress={() => setGender(g)}
                >
                  <Text
                    style={[
                      styles.genderText,
                      gender === g && styles.genderTextActive,
                    ]}
                  >
                    {g ? (g === 'm' ? 'Masculine' : 'Feminine') : 'None'}
                  </Text>
                </TouchableOpacity>
              ))}
            </View>

            <Input
              label="Example Sentence (optional)"
              placeholder="Enter an example sentence"
              value={example}
              onChangeText={setExample}
              multiline
            />
          </Card>

          <View style={styles.buttonContainer}>
            <Button title="Save Word" onPress={handleSave} loading={loading} />
          </View>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  scrollContent: {
    flexGrow: 1,
  },
  content: {
    padding: 20,
  },
  title: {
    fontSize: 28,
    fontWeight: '700',
    marginBottom: 24,
    color: '#000',
  },
  label: {
    fontSize: 14,
    fontWeight: '600',
    marginBottom: 8,
    color: '#333',
  },
  genderContainer: {
    flexDirection: 'row',
    marginBottom: 16,
    gap: 8,
  },
  genderButton: {
    flex: 1,
    paddingVertical: 10,
    paddingHorizontal: 12,
    borderRadius: 8,
    backgroundColor: '#e0e0e0',
    alignItems: 'center',
  },
  genderButtonActive: {
    backgroundColor: '#000',
  },
  genderText: {
    fontSize: 14,
    fontWeight: '500',
    color: '#666',
  },
  genderTextActive: {
    color: '#fff',
  },
  buttonContainer: {
    marginTop: 24,
  },
});
