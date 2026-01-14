import React from 'react';
import { TextInput, StyleSheet, View, Text } from 'react-native';

interface InputProps {
  placeholder: string;
  value: string;
  onChangeText: (text: string) => void;
  label?: string;
  autoCapitalize?: 'none' | 'sentences' | 'words';
  multiline?: boolean;
}

export const Input: React.FC<InputProps> = ({
  placeholder,
  value,
  onChangeText,
  label,
  autoCapitalize = 'sentences',
  multiline = false,
}) => {
  return (
    <View style={styles.container}>
      {label && <Text style={styles.label}>{label}</Text>}
      <TextInput
        style={[styles.input, multiline && styles.multiline]}
        placeholder={placeholder}
        value={value}
        onChangeText={onChangeText}
        autoCapitalize={autoCapitalize}
        multiline={multiline}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginBottom: 16,
  },
  label: {
    fontSize: 14,
    fontWeight: '600',
    marginBottom: 6,
    color: '#333',
  },
  input: {
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 8,
    paddingHorizontal: 14,
    paddingVertical: 12,
    fontSize: 16,
    backgroundColor: '#fafafa',
  },
  multiline: {
    minHeight: 80,
    textAlignVertical: 'top',
  },
});
