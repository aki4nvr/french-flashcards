import React, { useEffect, useState } from 'react';
import { View, StyleSheet, Text, ScrollView } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { Card } from '../components/Card';
import { Button } from '../components/Button';
import { getVocabulary, getSessions } from '../utils/storage';
import { Word, Session } from '../types';

export const HomeScreen: React.FC = () => {
  const navigation = useNavigation();
  const [wordCount, setWordCount] = useState(0);
  const [lastSession, setLastSession] = useState<Session | null>(null);
  const [totalSessions, setTotalSessions] = useState(0);

  useEffect(() => {
    const unsubscribe = navigation.addListener('focus', () => {
      loadStats();
    });
    loadStats();
    return unsubscribe;
  }, [navigation]);

  const loadStats = async () => {
    const vocabulary = await getVocabulary();
    const sessions = await getSessions();

    setWordCount(vocabulary.length);
    setTotalSessions(sessions.length);

    if (sessions.length > 0) {
      const sorted = [...sessions].sort(
        (a, b) => new Date(b.date).getTime() - new Date(a.date).getTime()
      );
      setLastSession(sorted[0]);
    }
  };

  const canPractice = wordCount >= 4;

  return (
    <ScrollView contentContainerStyle={styles.scrollContent}>
      <View style={styles.container}>
        <Text style={styles.title}>French Flashcards</Text>

        <View style={styles.statsRow}>
          <Card style={styles.statCard}>
            <Text style={styles.statNumber}>{wordCount}</Text>
            <Text style={styles.statLabel}>Words</Text>
          </Card>
          <Card style={styles.statCard}>
            <Text style={styles.statNumber}>{totalSessions}</Text>
            <Text style={styles.statLabel}>Sessions</Text>
          </Card>
        </View>

        {lastSession && (
          <Card style={styles.lastSessionCard}>
            <Text style={styles.lastSessionTitle}>Last Session</Text>
            <Text style={styles.lastSessionText}>
              {Math.round((lastSession.correct / lastSession.total) * 100)}% accuracy
            </Text>
            <Text style={styles.lastSessionDate}>
              {new Date(lastSession.date).toLocaleDateString()}
            </Text>
          </Card>
        )}

        <View style={styles.actionsContainer}>
          <Text style={styles.sectionTitle}>Quick Actions</Text>

          <Button
            title="Start Practice"
            onPress={() => navigation.navigate('Practice' as never)}
            disabled={!canPractice}
          />

          {!canPractice && (
            <Text style={styles.warningText}>
              Add at least 4 words to start practicing
            </Text>
          )}

          <View style={styles.secondaryButtons}>
            <Button
              title="Add New Word"
              onPress={() => navigation.navigate('AddWord' as never)}
              variant="secondary"
            />
            <Button
              title="View All Words"
              onPress={() => navigation.navigate('WordList' as never)}
              variant="secondary"
            />
          </View>
        </View>
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  scrollContent: {
    flexGrow: 1,
  },
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
    paddingTop: 60,
    paddingHorizontal: 20,
    minHeight: 700,
  },
  title: {
    fontSize: 32,
    fontWeight: '700',
    color: '#000',
    marginBottom: 32,
  },
  statsRow: {
    flexDirection: 'row',
    gap: 12,
    marginBottom: 16,
  },
  statCard: {
    flex: 1,
    alignItems: 'center',
    paddingVertical: 24,
  },
  statNumber: {
    fontSize: 36,
    fontWeight: '700',
    color: '#000',
  },
  statLabel: {
    fontSize: 14,
    color: '#666',
    marginTop: 4,
  },
  lastSessionCard: {
    marginBottom: 32,
    paddingVertical: 20,
    paddingHorizontal: 20,
  },
  lastSessionTitle: {
    fontSize: 14,
    color: '#666',
    marginBottom: 4,
  },
  lastSessionText: {
    fontSize: 24,
    fontWeight: '600',
    color: '#000',
  },
  lastSessionDate: {
    fontSize: 14,
    color: '#999',
    marginTop: 4,
  },
  actionsContainer: {
    flex: 1,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#333',
    marginBottom: 16,
  },
  warningText: {
    fontSize: 14,
    color: '#ff3b30',
    textAlign: 'center',
    marginTop: 8,
    marginBottom: 16,
  },
  secondaryButtons: {
    marginTop: 12,
    gap: 10,
  },
});
