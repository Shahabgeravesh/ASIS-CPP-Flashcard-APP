import SwiftUI

struct FavoritesView: View {
    @ObservedObject var chapterStore: ChapterStore
    @State private var currentCardIndex = 0
    @State private var showingAnswer = false
    @State private var cardOffset = CGSize.zero
    @Environment(\.colorScheme) var colorScheme
    
    private var favoriteCards: [(chapterIndex: Int, flashcardIndex: Int, flashcard: Flashcard)] {
        chapterStore.getFavoriteFlashcards()
    }
    
    var body: some View {
        ZStack {
            // System background
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack {
                if favoriteCards.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "star.slash")
                            .font(.system(size: 60))
                            .foregroundStyle(Color(.systemBlue))
                        
                        Text("No Favorites Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color(.label))
                        
                        Text("Add cards to your favorites by tapping the star icon while studying")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color(.secondaryLabel))
                            .padding(.horizontal)
                    }
                    .padding()
                } else {
                    VStack {
                        // Progress indicator
                        Text("\(currentCardIndex + 1) of \(favoriteCards.count)")
                            .font(.subheadline)
                            .foregroundStyle(Color(.secondaryLabel))
                            .padding(.top)
                        
                        // Flashcard
                        ZStack {
                            // Front of card
                            if !showingAnswer {
                                VStack(spacing: 20) {
                                    Text(favoriteCards[currentCardIndex].flashcard.question)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(Color(.label))
                                        .padding()
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        withAnimation {
                                            showingAnswer = true
                                        }
                                    }) {
                                        Text("Show Answer")
                                            .font(.headline)
                                            .foregroundStyle(Color(.label))
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color(.systemBlue))
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                    .padding(.horizontal)
                                    
                                    Button(action: {
                                        chapterStore.toggleFavorite(
                                            chapterIndex: favoriteCards[currentCardIndex].chapterIndex,
                                            flashcardIndex: favoriteCards[currentCardIndex].flashcardIndex
                                        )
                                        handleCardRemoval()
                                    }) {
                                        HStack {
                                            Image(systemName: "star.slash.fill")
                                            Text("Remove from Favorites")
                                        }
                                        .foregroundStyle(Color(.systemRed))
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color(.systemRed).opacity(0.1))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom)
                                }
                                .frame(maxWidth: .infinity, maxHeight: 400)
                                .background(Color(.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(color: Color(.systemGray), radius: 10, x: 0, y: 5)
                                .rotation3DEffect(
                                    .degrees(showingAnswer ? 180 : 0),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                            }
                            
                            // Back of card
                            if showingAnswer {
                                VStack(spacing: 20) {
                                    Text(favoriteCards[currentCardIndex].flashcard.answer)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(Color(.label))
                                        .padding()
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        withAnimation {
                                            showingAnswer = false
                                        }
                                    }) {
                                        Text("Show Question")
                                            .font(.headline)
                                            .foregroundStyle(Color(.label))
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color(.systemBlue))
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                    .padding(.horizontal)
                                    
                                    Button(action: {
                                        chapterStore.toggleFavorite(
                                            chapterIndex: favoriteCards[currentCardIndex].chapterIndex,
                                            flashcardIndex: favoriteCards[currentCardIndex].flashcardIndex
                                        )
                                        handleCardRemoval()
                                    }) {
                                        HStack {
                                            Image(systemName: "star.slash.fill")
                                            Text("Remove from Favorites")
                                        }
                                        .foregroundStyle(Color(.systemRed))
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color(.systemRed).opacity(0.1))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom)
                                }
                                .frame(maxWidth: .infinity, maxHeight: 500)
                                .background(Color(.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(color: Color(.systemGray), radius: 10, x: 0, y: 5)
                                .rotation3DEffect(
                                    .degrees(showingAnswer ? 0 : -180),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                            }
                        }
                        .padding()
                        
                        // Navigation buttons
                        HStack(spacing: 40) {
                            Button(action: previousCard) {
                                Image(systemName: "arrow.left.circle.fill")
                                    .font(.system(size: 44))
                                    .foregroundStyle(Color(.systemBlue))
                            }
                            .disabled(currentCardIndex == 0)
                            .opacity(currentCardIndex == 0 ? 0.5 : 1)
                            
                            Button(action: nextCard) {
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.system(size: 44))
                                    .foregroundStyle(Color(.systemBlue))
                            }
                            .disabled(currentCardIndex == favoriteCards.count - 1)
                            .opacity(currentCardIndex == favoriteCards.count - 1 ? 0.5 : 1)
                        }
                        .padding(.bottom)
                    }
                }
            }
        }
        .navigationTitle("Favorites")
    }
    
    private func nextCard() {
        if currentCardIndex < favoriteCards.count - 1 {
            withAnimation {
                currentCardIndex += 1
                showingAnswer = false
            }
        }
    }
    
    private func previousCard() {
        if currentCardIndex > 0 {
            withAnimation {
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
                .foregroundColor(Color("FFD54F"))
            
            Text("No Favorite Cards")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color("4A6572"))
            
            Text("Tap the star icon while studying to add favorites")
                .font(.body)
                .foregroundColor(Color("6B8C9A"))
                .multilineTextAlignment(.center)
        }
        .padding()
    }
} 