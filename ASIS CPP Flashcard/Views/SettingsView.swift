import SwiftUI

struct SettingsView: View {
    @ObservedObject var chapterStore: ChapterStore
    @ObservedObject private var settings = UserSettings.shared
    @State private var showingResetAlert = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // App Info Card
                VStack(spacing: 16) {
                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    
                    Text("ASIS CPP Flashcards")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Version 3.7.3")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.secondarySystemBackground))
                )
                .padding(.horizontal)
                
                // Settings Options
                VStack(spacing: 16) {
                    // Dark Mode Toggle
                    HStack {
                        Image(systemName: "moon.fill")
                            .foregroundColor(.blue)
                            .frame(width: 24)
                        
                        Text("Dark Mode")
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Toggle("", isOn: $settings.isDarkMode)
                            .labelsHidden()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                    )
                    
                    // Reset Progress Button
                    Button(action: {
                        showingResetAlert = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                                .foregroundColor(.red)
                                .frame(width: 24)
                            
                            Text("Reset All Progress")
                                .foregroundColor(.red)
                            
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.secondarySystemBackground))
                        )
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 32)
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