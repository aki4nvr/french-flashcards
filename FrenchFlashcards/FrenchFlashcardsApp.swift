import SwiftUI

@main
struct FrenchFlashcardsApp: App {
    @StateObject private var wordStore = WordStore()
    @StateObject private var sessionStore = SessionStore()

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    HomeView()
                }
                .tabItem {
                    Label("Home", systemImage: "house")
                }

                NavigationStack {
                    AddWordView()
                }
                .tabItem {
                    Label("Add", systemImage: "plus.circle")
                }

                NavigationStack {
                    WordListView()
                }
                .tabItem {
                    Label("Words", systemImage: "list.bullet")
                }

                NavigationStack {
                    PracticeView()
                }
                .tabItem {
                    Label("Practice", systemImage: "checkmark.circle")
                }
            }
            .environmentObject(wordStore)
            .environmentObject(sessionStore)
        }
    }
}
