import SwiftUI

struct ChapterView: View {
    let chapter: Chapter
    let chapterIndex: Int
    @ObservedObject var chapterStore: ChapterStore
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAnswer = false
    @State private var currentCardIndex: Int
    @State private var isTransitioning = false
    @State private var showingCompletionAlert = false
    @State private var showingProgressView = false
    @State private var offset = CGSize.zero
    
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
    
    private var activeCards: [Flashcard] {
        chapter.flashcards.filter { !$0.isMastered }
    }
    
    var body: some View {
        Group {
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
                                .font(AppTheme.headlineFont)
                                .foregroundColor(AppTheme.primary)
                            
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
                                        .font(AppTheme.captionFont)
                                    Image(systemName: "chart.bar.fill")
                                }
                                .foregroundColor(AppTheme.secondary)
                            }
                        }
                        .padding(.horizontal)
                        
                        ProgressView(value: progressPercentage, total: 100)
                            .tint(AppTheme.success)
                            .padding(.horizontal)
                    }
                    
                    // Card counter
                    Text("Card \(currentCardIndex + 1) of \(activeCards.count)")
                        .font(AppTheme.captionFont)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // Flashcard
                    FlashcardView(
                        flashcard: activeCards[currentCardIndex],
                        showingAnswer: $showingAnswer,
                        onAnswerViewed: {
                            let originalIndex = chapter.flashcards.firstIndex(where: { $0.id == activeCards[currentCardIndex].id })!
                            chapterStore.markFlashcardAsReviewed(
                                chapterIndex: chapterIndex,
                                flashcardIndex: originalIndex
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
                            let originalIndex = chapter.flashcards.firstIndex(where: { $0.id == activeCards[currentCardIndex].id })!
                            chapterStore.toggleFavorite(
                                chapterIndex: chapterIndex,
                                flashcardIndex: originalIndex
                            )
                        }
                    )
                    
                    Spacer()
                    
                    // Swipe Guide
                    HStack(spacing: 40) {
                        // Left swipe guide
                        VStack(spacing: 4) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(AppTheme.secondary)
                            Text("Swipe Left")
                                .font(AppTheme.captionFont)
                                .foregroundColor(AppTheme.secondary)
                            Text("Need Review")
                                .font(AppTheme.captionFont)
                                .foregroundColor(.red)
                        }
                        
                        // Right swipe guide
                        VStack(spacing: 4) {
                            Image(systemName: "arrow.right")
                                .foregroundColor(AppTheme.secondary)
                            Text("Swipe Right")
                                .font(AppTheme.captionFont)
                                .foregroundColor(AppTheme.secondary)
                            Text("Mastered")
                                .font(AppTheme.captionFont)
                                .foregroundColor(AppTheme.success)
                        }
                    }
                    .padding(.bottom, 20)
                }
                .navigationTitle("Chapter \(chapter.number)")
                .navigationBarTitleDisplayMode(.inline)
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17))
                        Text("Chapters")
                            .font(.system(size: 17))
                    }
                    .foregroundColor(AppTheme.secondary)
                }
            }
        }
        .background(AppTheme.cardBackground)
    }
    
    private func moveToNextCard() {
        withAnimation {
            if currentCardIndex < activeCards.count - 1 {
                currentCardIndex += 1
            } else {
                currentCardIndex = 0
            }
            showingAnswer = false
        }
    }
    
    private func handleMastered() {
        let originalIndex = chapter.flashcards.firstIndex(where: { $0.id == activeCards[currentCardIndex].id })!
        chapterStore.markFlashcardAsMastered(
            chapterIndex: chapterIndex,
            flashcardIndex: originalIndex
        )
        
        // Check if this was the last card to master
        let remainingUnmastered = chapter.flashcards.filter { !$0.isMastered }.count
        if remainingUnmastered <= 1 {  // Including the current card
            showingCompletionAlert = true
        }
    }
    
    private func handleNeedsReview() {
        let originalIndex = chapter.flashcards.firstIndex(where: { $0.id == activeCards[currentCardIndex].id })!
        chapterStore.markFlashcardForReview(
            chapterIndex: chapterIndex,
            flashcardIndex: originalIndex
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
                .foregroundColor(AppTheme.accent)
            
            Text("Chapter Mastered!")
                .font(AppTheme.titleFont)
            
            Text("Congratulations! You've completed Chapter \(chapter.number)")
                .font(AppTheme.headlineFont)
            
            Text("100% Mastered")
                .font(AppTheme.headlineFont)
                .foregroundColor(AppTheme.success)
            
            Text("Keep up the great work!")
                .font(AppTheme.bodyFont)
                .foregroundColor(.secondary)
        }
        .padding()
        .multilineTextAlignment(.center)
        .background(AppTheme.cardBackground)
    }
} 
