import SwiftUI

struct SettingsView: View {
    @ObservedObject var chapterStore: ChapterStore
    @ObservedObject private var settings = UserSettings.shared
    @State private var showingResetAlert = false
    
    var body: some View {
        List {
            Section(header: Text("Appearance")) {
                Toggle("Dark Mode", isOn: $settings.isDarkMode)
            }
            
            Section(header: Text("Data Management")) {
                Button(action: {
                    showingResetAlert = true
                }) {
                    HStack {
                        Text("Reset All Progress")
                            .foregroundColor(.red)
                        Spacer()
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
            }
            
            Section(header: Text("About")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("ASIS CPP Flashcards")
                        .font(.headline)
                    Text("Version 3.7.3")
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
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
} 