import SwiftUI

struct SettingsView: View {
    @ObservedObject var chapterStore: ChapterStore
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showingResetAlert = false
    
    var body: some View {
        List {
            // Appearance Section
            Section {
                HStack {
                    Label {
                        Text("Dark Mode")
                            .foregroundColor(.primary)
                    } icon: {
                        Image(systemName: isDarkMode ? "moon.fill" : "moon")
                            .foregroundColor(isDarkMode ? .purple : .gray)
                            .font(.system(size: 20))
                    }
                    Spacer()
                    Toggle("", isOn: $isDarkMode)
                        .labelsHidden()
                }
                .contentShape(Rectangle())
            } header: {
                Text("Appearance")
                    .font(AppTheme.headlineFont)
                    .foregroundColor(AppTheme.secondary)
            }
            
            // Actions Section
            Section {
                Button(action: {
                    showingResetAlert = true
                }) {
                    HStack {
                        Label {
                            Text("Reset All Progress")
                                .foregroundColor(.red)
                        } icon: {
                            Image(systemName: "arrow.counterclockwise")
                                .foregroundColor(.red)
                                .font(.system(size: 20))
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .foregroundColor(.gray.opacity(0.5))
                    }
                }
            } header: {
                Text("Actions")
                    .font(AppTheme.headlineFont)
                    .foregroundColor(AppTheme.secondary)
            }
            
            // About Section
            Section {
                VStack(spacing: 8) {
                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 40))
                        .foregroundColor(AppTheme.primary)
                    
                    Text("ASIS CPP Flashcards")
                        .font(AppTheme.titleFont)
                    
                    Text("Version 3.4")
                        .font(AppTheme.captionFont)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            } header: {
                Text("About")
                    .font(AppTheme.headlineFont)
                    .foregroundColor(AppTheme.secondary)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Reset All Progress", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                chapterStore.resetAllProgress()
            }
        } message: {
            Text("Warning: This will permanently erase all your progress. This action cannot be undone. Are you sure you want to continue?")
        }
    }
    
    // Helper functions for stats
    private func getTotalCards() -> Int {
        chapterStore.chapters.reduce(0) { $0 + $1.flashcards.count }
    }
    
    private func getMasteredCards() -> Int {
        chapterStore.chapters.reduce(0) { $0 + $1.flashcards.filter { $0.isMastered }.count }
    }
    
    private func getFavoriteCards() -> Int {
        chapterStore.chapters.reduce(0) { $0 + $1.flashcards.filter { $0.isFavorite }.count }
    }
}

// Helper view for stats row
struct StatRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 20))
                .frame(width: 30)
            
            Text(title)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.system(.body, design: .rounded).bold())
                .foregroundColor(color)
        }
    }
} 
