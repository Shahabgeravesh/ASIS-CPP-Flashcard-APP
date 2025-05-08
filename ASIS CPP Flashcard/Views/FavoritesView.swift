import SwiftUI

struct FavoritesView: View {
    @ObservedObject var chapterStore: ChapterStore
    @State private var currentCardIndex = 0
    @State private var showingAnswer = false
    @State private var cardOffset = CGSize.zero
    
    private var favoriteCards: [(chapterIndex: Int, flashcardIndex: Int, flashcard: Flashcard)] {
        chapterStore.getFavoriteFlashcards()
    }
    
    var body: some View {
        VStack {
            if favoriteCards.isEmpty {
                NoFavoritesView()
            } else {
                let currentCard = favoriteCards[currentCardIndex]
                
                // Progress counter (not progress tracking)
                VStack(spacing: 8) {
                    Text("\(currentCardIndex + 1) of \(favoriteCards.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                Spacer()
                
                // Card view with horizontal swipe for navigation only
                VStack(spacing: 20) {
                    // Card content
                    VStack {
                        if showingAnswer {
                            ScrollView {
                                Text(currentCard.flashcard.answer)
                                    .font(.title3)
                                    .padding()
                                    .multilineTextAlignment(.center)
                            }
                        } else {
                            Text(currentCard.flashcard.question)
                                .font(.title3)
                                .padding()
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 10)
                    .offset(x: cardOffset.width)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                cardOffset = gesture.translation
                            }
                            .onEnded { gesture in
                                let threshold: CGFloat = 50
                                withAnimation(.spring()) {
                                    if gesture.translation.width > threshold && currentCardIndex > 0 {
                                        moveToPreviousCard()
                                    } else if gesture.translation.width < -threshold && currentCardIndex < favoriteCards.count - 1 {
                                        moveToNextCard()
                                    }
                                    cardOffset = .zero
                                }
                            }
                    )
                    
                    // Controls
                    VStack(spacing: 16) {
                        Button(action: { showingAnswer.toggle() }) {
                            Text(showingAnswer ? "Show Question" : "Show Answer")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Color.blue)
                                .cornerRadius(15)
                        }
                        
                        Button(action: {
                            chapterStore.toggleFavorite(
                                chapterIndex: currentCard.chapterIndex,
                                flashcardIndex: currentCard.flashcardIndex
                            )
                            handleCardRemoval()
                        }) {
                            HStack {
                                Image(systemName: "star.slash.fill")
                                Text("Remove from Favorites")
                            }
                            .foregroundColor(.red)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(15)
                        }
                    }
                }
                .padding()
                
                Spacer()
                
                // Navigation buttons
                HStack(spacing: 40) {
                    Button(action: moveToPreviousCard) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    .disabled(currentCardIndex == 0)
                    .opacity(currentCardIndex == 0 ? 0.5 : 1)
                    
                    Button(action: moveToNextCard) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    .disabled(currentCardIndex == favoriteCards.count - 1)
                    .opacity(currentCardIndex == favoriteCards.count - 1 ? 0.5 : 1)
                }
                .padding(.bottom)
            }
        }
        .navigationTitle("Favorites")
        .onChange(of: favoriteCards.count) { newCount in
            if newCount > 0 && currentCardIndex >= newCount {
                currentCardIndex = newCount - 1
            }
        }
    }
    
    private func moveToNextCard() {
        withAnimation {
            if currentCardIndex < favoriteCards.count - 1 {
                currentCardIndex += 1
                showingAnswer = false
            }
        }
    }
    
    private func moveToPreviousCard() {
        withAnimation {
            if currentCardIndex > 0 {
                currentCardIndex -= 1
                showingAnswer = false
            }
        }
    }
    
    private func handleCardRemoval() {
        if favoriteCards.count <= 1 {
            currentCardIndex = 0
            return
        }
        
        if currentCardIndex == favoriteCards.count - 1 {
            currentCardIndex -= 1
        }
    }
}

// Keep the existing NoFavoritesView
struct NoFavoritesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "star.slash")
                .font(.system(size: 60))
                .foregroundColor(.yellow)
            
            Text("No Favorite Cards")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Tap the star icon while studying to add favorites")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
} 