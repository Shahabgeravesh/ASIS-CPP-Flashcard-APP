//
//  ContentView.swift
//  ASIS CPP Flashcard
//
//  Created by Shahab Geravesh on 1/22/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var chapterStore = ChapterStore()
    @StateObject private var themeManager = ThemeManager()
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                DashboardView(chapterStore: chapterStore)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("Dashboard", systemImage: "chart.xyaxis.line")
            }
            .tag(0)
            
            NavigationView {
                ChapterListView(chapterStore: chapterStore)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("Chapters", systemImage: "book.closed.fill")
            }
            .tag(1)
            
            NavigationView {
                FavoritesView(chapterStore: chapterStore)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("Favorites", systemImage: "star.fill")
            }
            .tag(2)
            
            NavigationView {
                SettingsView(chapterStore: chapterStore)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
            .tag(3)
        }
        .accentColor(AppTheme.primary)
        .onAppear {
            themeManager.applyTheme()
        }
    }
}

// Separate view for each chapter card to improve performance and maintainability
struct ChapterCard: View {
    let chapter: Chapter
    let index: Int
    let chapterStore: ChapterStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Chapter title and progress button
            HStack {
                Text("Chapter \(chapter.number): \(chapter.title)")
                    .font(.headline)
                    .lineLimit(2)
                Spacer()
                NavigationLink {
                    ChapterProgressView(chapter: chapter, chapterIndex: index, chapterStore: chapterStore)
                } label: {
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(.blue)
                        .frame(width: 44, height: 44)
                }
            }
            
            // Progress section
            NavigationLink {
                ChapterView(chapter: chapter, chapterIndex: index, chapterStore: chapterStore)
            } label: {
                VStack(alignment: .leading, spacing: 8) {
                    ProgressView(value: chapter.progressPercentage, total: 100)
                        .tint(.green)
                    
                    HStack {
                        Text("\(max(0, min(100, Int(chapter.progressPercentage))))% Complete")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(chapter.flashcards.filter { $0.isReviewed }.count)/\(chapter.flashcards.count) Cards")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
