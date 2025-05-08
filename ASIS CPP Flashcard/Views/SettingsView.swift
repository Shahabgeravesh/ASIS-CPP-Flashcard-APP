import SwiftUI

struct SettingsView: View {
    @ObservedObject var chapterStore: ChapterStore
    @ObservedObject private var settings = UserSettings.shared
    @State private var showingResetAlert = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Sky-inspired background
            LinearGradient(
                colors: [
                    colorScheme == .dark ? Color("1A1A1A") : Color("E3F2FD"),
                    colorScheme == .dark ? Color("2A2A2A") : Color("BBDEFB")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            List {
                Section(header: Text("Appearance").foregroundColor(Color("4A6572"))) {
                    Toggle("Dark Mode", isOn: $settings.isDarkMode)
                        .foregroundColor(Color("4A6572"))
                }
                .listRowBackground(colorScheme == .dark ? Color("1A1A1A") : Color("F5F5F5"))
                
                Section(header: Text("Data Management").foregroundColor(Color("4A6572"))) {
                    Button(action: {
                        showingResetAlert = true
                    }) {
                        HStack {
                            Text("Reset All Progress")
                                .foregroundColor(Color("E57373"))
                            Spacer()
                            Image(systemName: "arrow.counterclockwise")
                                .foregroundColor(Color("E57373"))
                        }
                    }
                }
                .listRowBackground(colorScheme == .dark ? Color("1A1A1A") : Color("F5F5F5"))
                
                Section(header: Text("About").foregroundColor(Color("4A6572"))) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("ASIS CPP Flashcards")
                            .font(.headline)
                            .foregroundColor(Color("4A6572"))
                        Text("Version 3.7.3")
                            .foregroundColor(Color("6B8C9A"))
                    }
                    .padding(.vertical, 4)
                }
                .listRowBackground(colorScheme == .dark ? Color("1A1A1A") : Color("F5F5F5"))
            }
            .onAppear {
                // Set the list background color to clear
                UITableView.appearance().backgroundColor = .clear
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