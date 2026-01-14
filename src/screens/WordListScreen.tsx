import React, { useEffect, useState } from 'react';
import { View, StyleSheet, FlatList, TextInput, Alert, Text, TouchableOpacity } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { Card } from '../components/Card';
import { Button } from '../components/Button';
import { getVocabulary, deleteWord } from '../utils/storage';
import { Word } from '../types';

export const WordListScreen: React.FC = () => {
  const navigation = useNavigation();
  const [words, setWords] = useState<Word[]>([]);
  const [filteredWords, setFilteredWords] = useState<Word[]>([]);
  const [search, setSearch] = useState('');

  useEffect(() => {
    loadWords();
  }, []);

  useEffect(() => {
    if (search.trim() === '') {
      setFilteredWords(words);
    } else {
      const lower = search.toLowerCase();
      setFilteredWords(
        words.filter(
          w =>
            w.french.toLowerCase().includes(lower) ||
            w.english.toLowerCase().includes(lower)
        )
      );
    }
  }, [search, words]);

  const loadWords = async () => {
    const data = await getVocabulary();
    const sorted = data.sort(
      (a, b) => b.createdAt - a.createdAt
    );
    setWords(sorted);
    setFilteredWords(sorted);
  };

  const handleDelete = (id: string) => {
    Alert.alert('Delete Word', 'Are you sure you want to delete this word?', [
      { text: 'Cancel', style: 'cancel' },
      {
        text: 'Delete',
        style: 'destructive',
        onPress: async () => {
          await deleteWord(id);
          loadWords();
        },
      },
    ]);
  };

  const renderItem = ({ item }: { item: Word }) => (
    <Card style={styles.wordCard}>
      <View style={styles.wordRow}>
        <View style={styles.wordContent}>
          <Text style={styles.french}>{item.french}</Text>
          <Text style={styles.english}>{item.english}</Text>
          {item.gender && (
            <Text style={styles.gender}>
              {item.gender === 'm' ? 'masculine' : 'feminine'}
            </Text>
          )}
        </View>
        <TouchableOpacity
          style={styles.deleteButton}
          onPress={() => handleDelete(item.id)}
        >
          <Text style={styles.deleteText}>Delete</Text>
        </TouchableOpacity>
      </View>
    </Card>
  );

  const emptyState = () => (
    <View style={styles.emptyContainer}>
      <Text style={styles.emptyText}>No words yet</Text>
      <Text style={styles.emptySubtext}>
        Add some words to start building your vocabulary!
      </Text>
    </View>
  );

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>My Vocabulary</Text>
        <Text style={styles.count}>{filteredWords.length} words</Text>
      </View>

      <TextInput
        style={styles.searchInput}
        placeholder="Search words..."
        value={search}
        onChangeText={setSearch}
      />

      <FlatList
        data={filteredWords}
        renderItem={renderItem}
        keyExtractor={item => item.id}
        contentContainerStyle={styles.listContent}
        ListEmptyComponent={emptyState}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
    paddingTop: 60,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    marginBottom: 16,
  },
  title: {
    fontSize: 28,
    fontWeight: '700',
    color: '#000',
  },
  count: {
    fontSize: 16,
    color: '#666',
  },
  searchInput: {
    backgroundColor: '#fff',
    marginHorizontal: 20,
    marginBottom: 16,
    paddingHorizontal: 14,
    paddingVertical: 12,
    borderRadius: 8,
    fontSize: 16,
    borderWidth: 1,
    borderColor: '#ddd',
  },
  listContent: {
    paddingHorizontal: 20,
    paddingBottom: 20,
  },
  wordCard: {
    marginBottom: 10,
  },
  wordRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  wordContent: {
    flex: 1,
  },
  french: {
    fontSize: 18,
    fontWeight: '600',
    color: '#000',
  },
  english: {
    fontSize: 16,
    color: '#666',
    marginTop: 2,
  },
  gender: {
    fontSize: 12,
    color: '#999',
    marginTop: 4,
    fontStyle: 'italic',
  },
  deleteButton: {
    paddingHorizontal: 12,
    paddingVertical: 6,
  },
  deleteText: {
    color: '#ff3b30',
    fontWeight: '500',
  },
  emptyContainer: {
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 60,
  },
  emptyText: {
    fontSize: 18,
    fontWeight: '600',
    color: '#666',
  },
  emptySubtext: {
    fontSize: 14,
    color: '#999',
    marginTop: 8,
  },
});
