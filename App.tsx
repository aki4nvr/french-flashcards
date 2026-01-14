import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { HomeScreen } from './src/screens/HomeScreen';
import { AddWordScreen } from './src/screens/AddWordScreen';
import { WordListScreen } from './src/screens/WordListScreen';
import { PracticeScreen } from './src/screens/PracticeScreen';
import { StatusBar } from 'react-native';

export type RootStackParamList = {
  Home: undefined;
  AddWord: undefined;
  WordList: undefined;
  Practice: { sessionSize?: number };
};

const Stack = createNativeStackNavigator<RootStackParamList>();

export default function App() {
  return (
    <NavigationContainer>
      <StatusBar barStyle="dark-content" />
      <Stack.Navigator
        screenOptions={{
          headerStyle: {
            backgroundColor: '#f5f5f5',
          },
          headerTintColor: '#000',
          headerTitleStyle: {
            fontWeight: '600',
          },
          contentStyle: {
            backgroundColor: '#f5f5f5',
          },
        }}
      >
        <Stack.Screen
          name="Home"
          component={HomeScreen}
          options={{ headerShown: false }}
        />
        <Stack.Screen
          name="AddWord"
          component={AddWordScreen}
          options={{ title: 'Add Word' }}
        />
        <Stack.Screen
          name="WordList"
          component={WordListScreen}
          options={{ title: 'My Vocabulary' }}
        />
        <Stack.Screen
          name="Practice"
          component={PracticeScreen}
          options={{ title: 'Practice', headerBackTitle: 'Quit' }}
        />
      </Stack.Navigator>
    </NavigationContainer>
  );
}
