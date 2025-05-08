import SwiftUI

struct SettingsView: View {
    @ObservedObject var chapterStore: ChapterStore
    @ObservedObject private var settings = UserSettings.shared
    @State private var showingResetAlert = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // System background
            Color(.systemBackground)
                .ignoresSafeArea()
            
            List {
                Section {
                    Toggle("Dark Mode", isOn: $settings.isDarkMode)
                        .foregroundStyle(Color(.label))
                } header: {
                    Text("Appearance")
                        .sectionHeaderStyle()
                }
                .listRowBackground(Color(.systemBackground))
                
                Section {
                    Button(action: {
                        showingResetAlert = true
                    }) {
                        HStack {
                            Text("Reset All Progress")
                                .foregroundStyle(Color(.systemRed))
                            Spacer()
                            Image(systemName: "arrow.counterclockwise")
                                .foregroundStyle(Color(.systemRed))
                        }
                    }
                } header: {
                    Text("Data Management")
                        .sectionHeaderStyle()
                }
                .listRowBackground(Color(.systemBackground))
                
                Section {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.s) {
                        Text("ASIS CPP Flashcards")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(ColorTheme.Text.primary)
                        Text("Version 3.7.3")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(ColorTheme.Text.secondary)
                    }
                    .padding(.vertical, DesignSystem.Spacing.s)
                } header: {
                    Text("About")
                        .sectionHeaderStyle()
                }
                .listRowBackground(ColorTheme.Background.listRow(for: colorScheme))
            }
            .onAppear {
                // Set the list background color to clear
                UITableView.appearance().backgroundColor = .clear
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Reset Progress", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                chapterStore.resetAllProgress()
            }
        } message: {
            Text("Are you sure you want to reset all progress? This action cannot be undone.")
        }
    }
} 