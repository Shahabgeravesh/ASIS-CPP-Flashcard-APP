import SwiftUI

struct MarkedCardsView: View {
    @ObservedObject var chapterStore: ChapterStore
    @State private var currentCardIndex = 0
    @State private var showingAnswer = false
    @State private var offset = CGSize.zero
    
    private var markedCards: [(chapterIndex: Int, cardIndex: Int, card: Flashcard)] {
        var cards: [(chapterIndex: Int, cardIndex: Int, card: Flashcard)] = []
        for (chapterIndex, chapter) in chapterStore.chapters.enumerated() {
            for (cardIndex, card) in chapter.flashcards.enumerated() {
                if !card.isMastered {
                    cards.append((chapterIndex, cardIndex, card))
                }
            }
        }
        return cards
    }
    
    var body: some View {
        VStack {
            if markedCards.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                    
                    Text("No Cards for Review")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("All cards have been mastered!")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            } else {
                // Progress indicator
                VStack(spacing: 8) {
                    ProgressView(value: Double(currentCardIndex + 1), total: Double(markedCards.count))
                        .padding(.horizontal)
                    
                    Text("\(currentCardIndex + 1) of \(markedCards.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                Spacer()
                
                let currentCard = markedCards[currentCardIndex]
                FlashcardView(
                    flashcard: currentCard.card,
                    showingAnswer: $showingAnswer,
                    onAnswerViewed: {
                        chapterStore.markFlashcardAsReviewed(
                            chapterIndex: currentCard.chapterIndex,
                            flashcardIndex: currentCard.cardIndex
                        )
                    },
                    onSwipeLeft: {
                        handleNeedsReview(chapterIndex: currentCard.chapterIndex,
                                        flashcardIndex: currentCard.cardIndex)
                    },
                    onSwipeRight: {
                        handleMastered(chapterIndex: currentCard.chapterIndex,
                                     flashcardIndex: currentCard.cardIndex)
                    },
                    offset: $offset,
                    onFavoriteToggle: {
                        chapterStore.toggleFavorite(
                            chapterIndex: currentCard.chapterIndex,
                            flashcardIndex: currentCard.cardIndex
                        )
                    }
                )
                .offset(offset)
                
                Spacer()
                
                // Swipe instructions
                HStack(spacing: 20) {
                    Label("Swipe left to review again", systemImage: "arrow.left")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Label("Swipe right when mastered", systemImage: "arrow.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom)
            }
        }
        .navigationTitle("Review Cards")
    }
    
    private func handleMastered(chapterIndex: Int, flashcardIndex: Int) {
        chapterStore.markFlashcardAsMastered(
            chapterIndex: chapterIndex,
            flashcardIndex: flashcardIndex
        )
        moveToNextCard()
    }
    
    private func handleNeedsReview(chapterIndex: Int, flashcardIndex: Int) {
        chapterStore.markFlashcardForReview(
            chapterIndex: chapterIndex,
            flashcardIndex: flashcardIndex
        )
        moveToNextCard()
    }
    
    private func moveToNextCard() {
        withAnimation {
            if currentCardIndex < markedCards.count - 1 {
                currentCardIndex += 1
            } else {
                if !markedCards.isEmpty {
                    currentCardIndex = 0
                }
            }
            showingAnswer = false
            offset = .zero
        }
    }
} 