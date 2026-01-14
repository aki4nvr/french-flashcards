import React, { useEffect, useState, useCallback } from 'react';
import { View, StyleSheet, Text, TextInput, Alert, ScrollView, TouchableOpacity } from 'react-native';
import { useNavigation, useRoute, RouteProp } from '@react-navigation/native';
import { Card } from '../components/Card';
import { Button } from '../components/Button';
import { ProgressBar } from '../components/ProgressBar';
import { getVocabulary, saveSession } from '../utils/storage';
import { Word, PracticeMode, PracticeQuestion } from '../types';
import { generateDistractors, generateQuestions, checkAnswer } from '../utils/helpers';

type PracticeStackParamList = {
  Practice: { sessionSize?: number };
};

type PracticeScreenRouteProp = RouteProp<PracticeStackParamList, 'Practice'>;

export const PracticeScreen: React.FC = () => {
  const navigation = useNavigation();
  const route = useRoute<PracticeScreenRouteProp>();
  const sessionSize = route.params?.sessionSize || 10;

  const [questions, setQuestions] = useState<PracticeQuestion[]>([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [score, setScore] = useState(0);
  const [selectedAnswer, setSelectedAnswer] = useState<string | null>(null);
  const [typingAnswer, setTypingAnswer] = useState('');
  const [showFeedback, setShowFeedback] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadQuestions();
  }, []);

  const loadQuestions = async () => {
    const vocabulary = await getVocabulary();
    if (vocabulary.length < 4) {
      Alert.alert(
        'Not Enough Words',
        'You need at least 4 words to start a practice session.',
        [{ text: 'OK', onPress: () => navigation.goBack() }]
      );
      return;
    }

    const selectedWords = generateQuestions(vocabulary, sessionSize);
    const newQuestions: PracticeQuestion[] = selectedWords.map(word => {
      const isMultipleChoice = Math.random() > 0.5;
      return {
        type: isMultipleChoice ? 'multiple-choice' : 'typing',
        word,
        options: isMultipleChoice
          ? [word.english, ...generateDistractors(word, vocabulary)]
              .sort(() => Math.random() - 0.5)
          : undefined,
      };
    });

    setQuestions(newQuestions);
    setLoading(false);
  };

  const currentQuestion = questions[currentIndex];
  const progress = (currentIndex + 1) / questions.length;

  const handleAnswer = useCallback(
    (answer: string) => {
      if (showFeedback) return;

      setSelectedAnswer(answer);
      const isCorrect = checkAnswer(answer, currentQuestion.word.english);

      if (isCorrect) {
        setScore(s => s + 1);
      }

      setShowFeedback(true);
    },
    [currentQuestion, showFeedback]
  );

  const handleTypingSubmit = useCallback(() => {
    if (!typingAnswer.trim() || showFeedback) return;
    handleAnswer(typingAnswer);
  }, [typingAnswer, showFeedback, handleAnswer]);

  const nextQuestion = useCallback(async () => {
    if (currentIndex < questions.length - 1) {
      setCurrentIndex(i => i + 1);
      setSelectedAnswer(null);
      setTypingAnswer('');
      setShowFeedback(false);
    } else {
      const session = {
        date: new Date().toISOString(),
        correct: score + (showFeedback && checkAnswer(selectedAnswer || typingAnswer, currentQuestion.word.english) ? 1 : 0),
        total: questions.length,
      };
      await saveSession(session);

      const finalScore = showFeedback && checkAnswer(selectedAnswer || typingAnswer, currentQuestion.word.english)
        ? score + 1
        : score;

      Alert.alert(
        'Session Complete!',
        `You got ${finalScore} out of ${questions.length} correct.`,
        [{ text: 'OK', onPress: () => navigation.goBack() }]
      );
    }
  }, [currentIndex, questions.length, score, showFeedback, selectedAnswer, typingAnswer, currentQuestion]);

  if (loading) {
    return (
      <View style={styles.container}>
        <Text style={styles.loadingText}>Loading...</Text>
      </View>
    );
  }

  return (
    <ScrollView contentContainerStyle={styles.scrollContent}>
      <View style={styles.container}>
        <View style={styles.header}>
          <Text style={styles.progressText}>
            {currentIndex + 1} / {questions.length}
          </Text>
          <Text style={styles.scoreText}>Score: {score}</Text>
        </View>

        <ProgressBar progress={progress} />

        <Card style={styles.questionCard}>
          <Text style={styles.questionLabel}>Translate this word:</Text>
          <Text style={styles.wordText}>{currentQuestion.word.french}</Text>
          {currentQuestion.word.gender && (
            <Text style={styles.genderText}>
              ({currentQuestion.word.gender === 'm' ? 'masculine' : 'feminine'})
            </Text>
          )}
        </Card>

        {currentQuestion.type === 'multiple-choice' ? (
          <View style={styles.optionsContainer}>
            {currentQuestion.options?.map((option, index) => {
              let buttonStyle = styles.optionButton;
              let textStyle = styles.optionText;

              if (showFeedback) {
                if (option === currentQuestion.word.english) {
                  buttonStyle = styles.optionCorrect;
                  textStyle = styles.optionTextCorrect;
                } else if (option === selectedAnswer) {
                  buttonStyle = styles.optionWrong;
                  textStyle = styles.optionTextWrong;
                } else {
                  buttonStyle = styles.optionDisabled;
                }
              }

              return (
                <TouchableOpacity
                  key={index}
                  style={buttonStyle}
                  onPress={() => handleAnswer(option)}
                  disabled={showFeedback}
                >
                  <Text style={textStyle}>{option}</Text>
                </TouchableOpacity>
              );
            })}
          </View>
        ) : (
          <View style={styles.typingContainer}>
            <TextInput
              style={styles.textInput}
              placeholder="Type your answer..."
              value={typingAnswer}
              onChangeText={setTypingAnswer}
              onSubmitEditing={handleTypingSubmit}
              autoCapitalize="none"
            />
            <Button
              title="Submit"
              onPress={handleTypingSubmit}
              disabled={!typingAnswer.trim() || showFeedback}
            />
          </View>
        )}

        {showFeedback && (
          <View style={styles.feedbackContainer}>
            <Text
              style={[
                styles.feedbackText,
                checkAnswer(selectedAnswer || typingAnswer, currentQuestion.word.english)
                  ? styles.feedbackCorrect
                  : styles.feedbackWrong,
              ]}
            >
              {checkAnswer(selectedAnswer || typingAnswer, currentQuestion.word.english)
                ? 'Correct!'
                : `Wrong! The answer is "${currentQuestion.word.english}"`}
            </Text>
            {currentQuestion.word.example && (
              <Text style={styles.exampleText}>
                Example: {currentQuestion.word.example}
              </Text>
            )}
            <View style={styles.nextButtonContainer}>
              <Button title="Next" onPress={nextQuestion} />
            </View>
          </View>
        )}
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
    paddingTop: 60,
    minHeight: 600,
  },
  scrollContent: {
    flexGrow: 1,
  },
  loadingText: {
    fontSize: 18,
    textAlign: 'center',
    marginTop: 100,
    color: '#666',
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingHorizontal: 20,
    marginBottom: 8,
  },
  progressText: {
    fontSize: 16,
    color: '#666',
  },
  scoreText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#000',
  },
  questionCard: {
    marginHorizontal: 20,
    marginTop: 20,
    alignItems: 'center',
    paddingVertical: 30,
  },
  questionLabel: {
    fontSize: 16,
    color: '#666',
    marginBottom: 12,
  },
  wordText: {
    fontSize: 36,
    fontWeight: '700',
    color: '#000',
    textAlign: 'center',
  },
  genderText: {
    fontSize: 14,
    color: '#999',
    marginTop: 8,
    fontStyle: 'italic',
  },
  optionsContainer: {
    paddingHorizontal: 20,
    marginTop: 20,
  },
  optionButton: {
    backgroundColor: '#fff',
    paddingVertical: 16,
    paddingHorizontal: 20,
    borderRadius: 8,
    marginBottom: 10,
    borderWidth: 1,
    borderColor: '#ddd',
  },
  optionText: {
    fontSize: 16,
    color: '#333',
    textAlign: 'center',
  },
  optionCorrect: {
    backgroundColor: '#d4edda',
    paddingVertical: 16,
    paddingHorizontal: 20,
    borderRadius: 8,
    marginBottom: 10,
    borderWidth: 1,
    borderColor: '#28a745',
  },
  optionTextCorrect: {
    fontSize: 16,
    color: '#155724',
    textAlign: 'center',
    fontWeight: '600',
  },
  optionWrong: {
    backgroundColor: '#f8d7da',
    paddingVertical: 16,
    paddingHorizontal: 20,
    borderRadius: 8,
    marginBottom: 10,
    borderWidth: 1,
    borderColor: '#dc3545',
  },
  optionTextWrong: {
    fontSize: 16,
    color: '#721c24',
    textAlign: 'center',
  },
  optionDisabled: {
    backgroundColor: '#f5f5f5',
    paddingVertical: 16,
    paddingHorizontal: 20,
    borderRadius: 8,
    marginBottom: 10,
    borderWidth: 1,
    borderColor: '#ddd',
    opacity: 0.6,
  },
  typingContainer: {
    paddingHorizontal: 20,
    marginTop: 20,
  },
  textInput: {
    backgroundColor: '#fff',
    paddingHorizontal: 14,
    paddingVertical: 14,
    borderRadius: 8,
    fontSize: 16,
    borderWidth: 1,
    borderColor: '#ddd',
    marginBottom: 16,
  },
  feedbackContainer: {
    paddingHorizontal: 20,
    marginTop: 24,
  },
  feedbackText: {
    fontSize: 20,
    fontWeight: '600',
    textAlign: 'center',
    marginBottom: 8,
  },
  feedbackCorrect: {
    color: '#28a745',
  },
  feedbackWrong: {
    color: '#dc3545',
  },
  exampleText: {
    fontSize: 14,
    color: '#666',
    textAlign: 'center',
    fontStyle: 'italic',
    marginBottom: 20,
  },
  nextButtonContainer: {
    marginTop: 8,
  },
});
