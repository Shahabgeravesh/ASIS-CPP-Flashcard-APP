import SwiftUI

struct DashboardView: View {
    @ObservedObject var chapterStore: ChapterStore
    @State private var showingResetAlert = false
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
                            Text(progressEmoji)
                        }
                        Text(motivationalMessage)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 8)
            } header: {
                Text("Overall Progress")
            }
            
            // Quick Stats Section
            Section {
                HStack {
                    StatView(
                        title: "Mastered",
                        value: "\(chapterStore.chapters.reduce(0) { $0 + $1.flashcards.filter { $0.isMastered }.count })",
                        icon: "star.fill",
                        color: .yellow
                    )
                    
                    Divider()
                    
                    StatView(
                        title: "Total Cards",
                        value: "\(chapterStore.chapters.reduce(0) { $0 + $1.flashcards.count })",
                        icon: "square.stack.fill",
                        color: .blue
                    )
                }
                .padding(.vertical, 8)
            } header: {
                Text("Statistics")
            }
            
            // Chapter Progress Section
            Section {
                ForEach(chapterProgressData, id: \.chapter.number) { item in
                    VStack(spacing: 8) {
                        HStack {
                            Text("Chapter \(item.chapter.number)")
                                .font(.subheadline)
                                .bold()
                            Spacer()
                            Text("\(Int(item.progress))%")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        ProgressBar(progress: item.progress)
                    }
                    .padding(.vertical, 4)
                }
            } header: {
                Text("Chapter Progress")
            }
            
            // Reset Section
            Section {
                Button(action: {
                    showingResetAlert = true
                }) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Reset All Progress")
                    }
                    .foregroundColor(.red)
                }
            }
            .alert("Reset All Progress", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    chapterStore.resetAllProgress()
                }
            } message: {
                Text("Warning: This will permanently erase all your progress. This action cannot be undone. Are you sure you want to continue?")
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

struct StatView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title3)
                    .bold()
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
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