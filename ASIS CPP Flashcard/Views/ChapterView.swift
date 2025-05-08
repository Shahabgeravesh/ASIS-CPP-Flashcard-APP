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
        
        // Find the first unmastered card or start from the beginning
        let unmasteredCards = chapter.flashcards.indices.filter { !chapter.flashcards[$0].isMastered }
        let startIndex = unmasteredCards.isEmpty ? initialCardIndex : unmasteredCards[0]
        _currentCardIndex = State(initialValue: startIndex)
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
            // Sky-inspired background
            Color("E3F2FD")
                .ignoresSafeArea()
            
            VStack {
                if isChapterComplete {
                    ChapterCompletionView(chapter: chapter, chapterStore: chapterStore)
                } else {
                    VStack(spacing: 20) {
                        // Progress bar
                        VStack(spacing: 8) {
                            ProgressView(value: progressPercentage, total: 100)
                                .padding(.horizontal)
                        }
                        
                        // Card counter
                        Text("Card \(currentCardIndex + 1) of \(chapter.flashcards.count)")
                            .font(.subheadline)
                            .foregroundColor(Color("6B8C9A"))
                        
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
                        
                        // Quiz button
                        QuizButton(action: { showingQuiz = true })
                            .padding(.horizontal)
                    }
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
    
    private func moveToNextCard() {
        withAnimation {
            // Find the next unmastered card
            let unmasteredCards = chapter.flashcards.indices.filter { !chapter.flashcards[$0].isMastered }
            if let nextIndex = unmasteredCards.first(where: { $0 > currentCardIndex }) {
                currentCardIndex = nextIndex
            } else if !unmasteredCards.isEmpty {
                currentCardIndex = unmasteredCards[0]
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
    let chapterStore: ChapterStore
    
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
