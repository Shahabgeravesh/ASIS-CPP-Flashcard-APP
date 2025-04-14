import SwiftUI

struct SettingsView: View {
    @ObservedObject var chapterStore: ChapterStore
    @ObservedObject private var settings = UserSettings.shared
    @State private var showingResetAlert = false
    
    var body: some View {
        List {
            Section(header: Text("Instructions")) {
                VStack(alignment: .leading, spacing: 12) {
                    InstructionRow(
                        icon: "hand.tap",
                        title: "Tap card",
                        description: "to show the answer"
                    )
                    
                    InstructionRow(
                        icon: "hand.draw",
                        title: "Swipe right",
                        description: "when you've mastered the card"
                    )
                    
                    InstructionRow(
                        icon: "arrow.left",
                        title: "Swipe left",
                        description: "to mark for review"
                    )
                }
                .padding(.vertical, 8)
            }
            
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
                    Text("Version 3.7")
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

struct InstructionRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
} 