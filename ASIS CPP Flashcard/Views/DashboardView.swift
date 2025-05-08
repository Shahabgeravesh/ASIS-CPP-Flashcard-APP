import SwiftUI

struct DashboardView: View {
    @ObservedObject var chapterStore: ChapterStore
    @Environment(\.colorScheme) var colorScheme
    
    var overallProgress: Double {
        let totalCards = chapterStore.chapters.reduce(0) { $0 + $1.flashcards.count }
        let masteredCards = chapterStore.chapters.reduce(0) { $0 + $1.flashcards.filter { $0.isMastered }.count }
        return totalCards > 0 ? Double(masteredCards) / Double(totalCards) * 100 : 0
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
        ZStack {
            // System background
            LinearGradient(
                colors: ColorTheme.Background.gradient(for: colorScheme),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            List {
                // Overall Progress Section
                Section {
                    HStack(spacing: 20) {
                        CircularProgressView(progress: overallProgress)
                            .frame(width: 70, height: 70)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("\(Int(overallProgress))% Complete")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(ColorTheme.Text.primary)
                                Text(progressEmoji)
                            }
                            Text(motivationalMessage)
                                .font(.subheadline)
                                .foregroundColor(ColorTheme.Text.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("Overall Progress")
                        .foregroundColor(ColorTheme.Text.primary)
                }
                
                // Quick Stats Section
                Section {
                    HStack {
                        StatView(
                            title: "Mastered",
                            value: "\(chapterStore.chapters.reduce(0) { $0 + $1.flashcards.filter { $0.isMastered }.count })",
                            icon: "star.fill",
                            color: ColorTheme.Interactive.warning
                        )
                        
                        Divider()
                        
                        StatView(
                            title: "Total Cards",
                            value: "\(chapterStore.chapters.reduce(0) { $0 + $1.flashcards.count })",
                            icon: "square.stack.fill",
                            color: ColorTheme.Text.accent
                        )
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("Statistics")
                        .foregroundColor(ColorTheme.Text.primary)
                }
                
                // Chapter Progress Section
                Section {
                    ForEach(chapterProgressData, id: \.chapter.number) { item in
                        VStack(spacing: 8) {
                            HStack {
                                Text("Chapter \(item.chapter.number)")
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(ColorTheme.Text.primary)
                                Spacer()
                                Text("\(Int(item.progress))%")
                                    .font(.subheadline)
                                    .foregroundColor(ColorTheme.Text.secondary)
                            }
                            
                            ProgressBar(progress: item.progress)
                        }
                        .padding(.vertical, 4)
                    }
                } header: {
                    Text("Chapter Progress")
                        .foregroundColor(ColorTheme.Text.primary)
                }
            }
            .onAppear {
                // Set the list background color to clear
                UITableView.appearance().backgroundColor = .clear
            }
        }
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CircularProgressView: View {
    let progress: Double
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 6)
            
            Circle()
                .trim(from: 0, to: progress / 100)
                .stroke(
                    LinearGradient(
                        colors: [Color(.systemBlue), Color(.systemBlue).opacity(0.7)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
        }
    }
}

struct StatView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(color)
            
            Text(value)
                .font(.title2)
                .bold()
                .foregroundStyle(Color(.label))
            
            Text(title)
                .font(.caption)
                .foregroundStyle(Color(.secondaryLabel))
        }
        .frame(maxWidth: .infinity)
    }
}

struct ProgressBar: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: 8)
                    .opacity(0.1)
                    .foregroundStyle(Color(.systemGray5))
                
                Rectangle()
                    .frame(width: min(CGFloat(progress) / 100 * geometry.size.width, geometry.size.width), height: 8)
                    .foregroundStyle(Color(.systemBlue))
            }
            .cornerRadius(4)
        }
        .frame(height: 8)
    }
} 