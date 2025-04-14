import SwiftUI

struct ChapterView: View {
    let chapter: Chapter
    let chapterIndex: Int
    @ObservedObject var chapterStore: ChapterStore
    @State private var showingAnswer = false
    @State private var currentCardIndex: Int
    @State private var isTransitioning = false
    @State private var showingCompletionAlert = false
    @State private var showingProgressView = false
    @State private var offset = CGSize.zero
    @State private var showingQuiz = false
    
    init(chapter: Chapter, chapterIndex: Int, chapterStore: ChapterStore, initialCardIndex: Int = 0) {
        self.chapter = chapter
        self.chapterIndex = chapterIndex
        self.chapterStore = chapterStore
        _currentCardIndex = State(initialValue: initialCardIndex)
    }
    
    var unfinishedCards: [Int] {
        chapter.flashcards.indices.filter { !chapter.flashcards[$0].isMastered }
    }
    
    var progressPercentage: Double {
        let masteredCount = chapter.flashcards.filter { $0.isMastered }.count
        return Double(masteredCount) / Double(chapter.flashcards.count) * 100
    }
    
    var isChapterComplete: Bool {
        chapter.flashcards.allSatisfy { $0.isMastered }
    }
    
    var body: some View {
        ZStack {
            if chapter.flashcards.isEmpty {
                // Show message when no flashcards are available
                VStack {
                    Text("No flashcards available for this chapter")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding()
                }
                .navigationTitle("Chapter \(chapter.number)")
                .navigationBarTitleDisplayMode(.inline)
            } else if isChapterComplete {
                ChapterCompletionView(chapter: chapter)
            } else {
                VStack(spacing: 16) {
                    // Header with progress
                    VStack(spacing: 8) {
                        HStack {
                            Text("\(Int(progressPercentage))% Mastered")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            NavigationLink(isActive: $showingProgressView) {
                                ChapterProgressView(
                                    chapter: chapter,
                                    chapterIndex: chapterIndex,
                                    chapterStore: chapterStore
                                )
                            } label: {
                                HStack(spacing: 4) {
                                    Text("View Progress")
                                        .font(.subheadline)
                                    Image(systemName: "chart.bar.fill")
                                }
                                .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                        
                        ProgressView(value: progressPercentage, total: 100)
                            .padding(.horizontal)
                    }
                    
                    // Card counter
                    Text("Card \(currentCardIndex + 1) of \(chapter.flashcards.count)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // Flashcard
                    FlashcardView(
                        flashcard: chapter.flashcards[currentCardIndex],
                        showingAnswer: $showingAnswer,
                        onAnswerViewed: {
                            chapterStore.markFlashcardAsReviewed(
                                chapterIndex: chapterIndex,
                                flashcardIndex: currentCardIndex
                            )
                        },
                        onSwipeLeft: {
                            handleNeedsReview()
                            moveToNextCard()
                        },
                        onSwipeRight: {
                            handleMastered()
                            moveToNextCard()
                        },
                        offset: $offset,
                        onFavoriteToggle: {
                            chapterStore.toggleFavorite(
                                chapterIndex: chapterIndex,
                                flashcardIndex: currentCardIndex
                            )
                        }
                    )
                    
                    Spacer()
                    
                    // Update the quiz button section
                    VStack(spacing: 16) {
                        Divider()
                        
                        Button(action: {
                            showingQuiz = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "square.text.square.fill")
                                    .font(.title2)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Take Quiz")
                                        .font(.headline)
                                    
                                    Text("50 random questions")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.accentColor.opacity(0.1))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(Color.accentColor.opacity(0.3), lineWidth: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal)
                    }
                }
                .navigationTitle("Chapter \(chapter.number)")
                .navigationBarTitleDisplayMode(.inline)
                .fullScreenCover(isPresented: $showingQuiz) {
                    NavigationView {
                        QuizView(chapter: chapter, chapterStore: chapterStore)
                    }
                    .interactiveDismissDisabled()
                }
                .alert("Chapter Mastered! 🎉", isPresented: $showingCompletionAlert) {
                    Button("View Chapter Summary") {
                        withAnimation {
                            // The view will re-evaluate and show ChapterCompletionView
                        }
                    }
                } message: {
                    Text("Congratulations! You've mastered all cards in this chapter.")
                }
            }
        }
    }
    
    private func moveToNextCard() {
        withAnimation {
            if currentCardIndex < chapter.flashcards.count - 1 {
                currentCardIndex += 1
            } else {
                currentCardIndex = 0
            }
            showingAnswer = false
        }
    }
    
    private func handleMastered() {
        chapterStore.markFlashcardAsMastered(
            chapterIndex: chapterIndex,
            flashcardIndex: currentCardIndex
        )
        
        // Check if this was the last card to master
        let remainingUnmastered = chapter.flashcards.filter { !$0.isMastered }.count
        if remainingUnmastered <= 1 {  // Including the current card
            showingCompletionAlert = true
        }
    }
    
    private func handleNeedsReview() {
        chapterStore.markFlashcardForReview(
            chapterIndex: chapterIndex,
            flashcardIndex: currentCardIndex
        )
    }
}

// Update the completion view to always show 100%
struct ChapterCompletionView: View {
    let chapter: Chapter
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "star.fill")
                .font(.system(size: 60))
                .foregroundColor(.yellow)
            
            Text("Chapter Mastered!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Congratulations! You've completed Chapter \(chapter.number)")
                .font(.headline)
            
            Text("100% Mastered")
                .font(.title2)
                .foregroundColor(.green)
            
            Text("Keep up the great work!")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .multilineTextAlignment(.center)
    }
} 
