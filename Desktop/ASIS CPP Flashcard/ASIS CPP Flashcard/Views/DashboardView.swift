import SwiftUI

struct DashboardView: View {
    @ObservedObject var chapterStore: ChapterStore
    @State private var showingResetAlert = false
    @Environment(\.colorScheme) var colorScheme
    
    // Calculate additional statistics
    private var totalCards: Int {
        chapterStore.chapters.reduce(0) { $0 + $1.flashcards.count }
    }
    
    private var masteredCards: Int {
        chapterStore.chapters.reduce(0) { $0 + $1.flashcards.filter { $0.isMastered }.count }
    }
    
    private var favoriteCards: Int {
        chapterStore.chapters.reduce(0) { $0 + $1.flashcards.filter { $0.isFavorite }.count }
    }
    
    private var remainingCards: Int {
        totalCards - masteredCards
    }
    
    var overallProgress: Double {
        let totalCards = chapterStore.chapters.reduce(0) { $0 + $1.flashcards.count }
        let masteredCards = chapterStore.chapters.reduce(0) { $0 + $1.flashcards.filter { $0.isMastered }.count }
        return totalCards > 0 ? (Double(masteredCards) / Double(totalCards)) * 100.0 : 0.0
    }
    
    var motivationalMessage: String {
        switch overallProgress {
        case 0:
            return "Ready to start your CPP journey? Let's begin!"
        case 0..<20:
            return "Great start! Keep building your knowledge."
        case 20..<40:
            return "You're making steady progress. Keep it up!"
        case 40..<60:
            return "Halfway there! Your dedication is showing."
        case 60..<80:
            return "Impressive progress! The finish line is in sight."
        case 80..<100:
            return "Almost there! You're mastering the material."
        case 100:
            return "Outstanding! You've mastered all the content! 🎉"
        default:
            return "Keep going! You're doing great!"
        }
    }
    
    var progressEmoji: String {
        switch overallProgress {
        case 0:
            return "🚀"
        case 0..<20:
            return "💪"
        case 20..<40:
            return "📚"
        case 40..<60:
            return "⭐️"
        case 60..<80:
            return "🔥"
        case 80..<100:
            return "🎯"
        case 100:
            return "🏆"
        default:
            return "📝"
        }
    }
    
    var chapterProgressData: [(chapter: Chapter, progress: Double)] {
        chapterStore.chapters.map { chapter in
            let progress = chapter.progressPercentage
            return (chapter: chapter, progress: progress)
        }
    }
    
    var body: some View {
        List {
            // Study Progress Section
            Section {
                VStack(spacing: 16) {
                    // Progress Overview
                    VStack(alignment: .leading, spacing: 12) {
                        // Chapter Completion Distribution
                        HStack {
                            ProgressRing(
                                progress: Double(masteredCards) / Double(totalCards),
                                title: "Mastered",
                                color: AppTheme.success
                            )
                            
                            ProgressRing(
                                progress: Double(remainingCards) / Double(totalCards),
                                title: "To Review",
                                color: AppTheme.secondary
                            )
                            
                            if favoriteCards > 0 {
                                ProgressRing(
                                    progress: Double(favoriteCards) / Double(totalCards),
                                    title: "Favorites",
                                    color: .pink
                                )
                            }
                        }
                        .frame(height: 120)
                        .padding(.vertical, 8)
                        
                        // Motivational message
                        Text(motivationalMessage)
                            .font(AppTheme.captionFont)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        // Statistics boxes
                        HStack(spacing: 20) {
                            StatBox(
                                title: "Mastered",
                                value: "\(masteredCards)",
                                total: "\(totalCards)",
                                icon: "star.fill",
                                color: AppTheme.success
                            )
                            
                            StatBox(
                                title: "To Review",
                                value: "\(remainingCards)",
                                total: "\(totalCards)",
                                icon: "arrow.clockwise",
                                color: AppTheme.secondary
                            )
                        }
                        
                        StatBox(
                            title: "Favorites",
                            value: "\(favoriteCards)",
                            icon: "heart.fill",
                            color: .pink
                        )
                    }
                }
                .padding(.vertical, 8)
            } header: {
                Text("Study Progress")
                    .font(AppTheme.headlineFont)
                    .foregroundColor(AppTheme.secondary)
            }
            
            // Chapter Progress Section
            Section {
                ForEach(chapterProgressData, id: \.chapter.number) { item in
                    NavigationLink(destination: ChapterProgressView(chapter: item.chapter, chapterIndex: chapterStore.chapters.firstIndex(where: { $0.number == item.chapter.number }) ?? 0, chapterStore: chapterStore)) {
                        VStack(spacing: 8) {
                            HStack {
                                Text("Chapter \(item.chapter.number)")
                                    .font(AppTheme.headlineFont)
                                Spacer()
                                Text("\(Int(item.progress))%")
                                    .font(AppTheme.captionFont)
                                    .foregroundColor(AppTheme.secondary)
                            }
                            
                            ProgressBar(progress: item.progress)
                                .frame(height: 8)
                        }
                        .padding(.vertical, 4)
                    }
                }
            } header: {
                Text("Chapter Progress")
                    .font(AppTheme.headlineFont)
                    .foregroundColor(AppTheme.secondary)
            }
        }
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // Add these helper methods to DashboardView
    private func getLastSevenDays() -> [Date] {
        (0..<7).map { index in
            Calendar.current.date(byAdding: .day, value: -index, to: Date()) ?? Date()
        }.reversed()
    }
    
    private func getDailyProgress(for date: Date) -> CGFloat {
        // Calculate the progress for each day based on cards mastered that day
        let calendar = Calendar.current
        let cards = chapterStore.chapters.flatMap { $0.flashcards }
        let masteredToday = cards.filter { card in
            if let reviewDate = card.lastReviewDate,
               calendar.isDate(reviewDate, inSameDayAs: date) {
                return card.isMastered
            }
            return false
        }
        return CGFloat(masteredToday.count) / CGFloat(cards.count)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
}

struct CircularProgressView: View {
    let progress: Double
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.15), lineWidth: 6)
            
            Circle()
                .trim(from: 0, to: progress / 100)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .blue.opacity(0.7)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
        }
    }
}

struct StatBox: View {
    let title: String
    let value: String
    var total: String? = nil
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(AppTheme.captionFont)
                    .foregroundColor(.secondary)
            }
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(AppTheme.titleFont)
                    .foregroundColor(color)
                if let total = total {
                    Text("/ \(total)")
                        .font(AppTheme.captionFont)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct ProgressBar: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.15))
                    .frame(height: 6)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .blue.opacity(0.7)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * CGFloat(progress / 100), height: 6)
            }
        }
        .frame(height: 6)
    }
}

// Add this new ProgressRing view
struct ProgressRing: View {
    let progress: Double
    let title: String
    let color: Color
    
    private var displayPercentage: Int {
        Int((progress * 100).rounded())  // Simply round the actual progress
    }
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.15), lineWidth: 8)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        color,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: progress)
                
                VStack(spacing: 2) {
                    Text("\(displayPercentage)%")
                        .font(.system(.body, design: .rounded).bold())
                        .foregroundColor(color)
                }
            }
            
            Text(title)
                .font(AppTheme.captionFont)
                .foregroundColor(.secondary)
        }
    }
} 