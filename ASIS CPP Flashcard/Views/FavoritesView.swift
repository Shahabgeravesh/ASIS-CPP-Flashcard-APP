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
            // Sky-inspired background
            LinearGradient(
                colors: [
                    colorScheme == .dark ? Color("1A1A1A") : Color("E3F2FD"),
                    colorScheme == .dark ? Color("2A2A2A") : Color("BBDEFB")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                if favoriteCards.isEmpty {
                    NoFavoritesView()
                } else {
                    let currentCard = favoriteCards[currentCardIndex]
                    
                    // Progress counter (not progress tracking)
                    VStack(spacing: 8) {
                        Text("\(currentCardIndex + 1) of \(favoriteCards.count)")
                            .font(.caption)
                            .foregroundColor(Color("6B8C9A"))
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
                                        .foregroundColor(Color("4A6572"))
                                }
                            } else {
                                Text(currentCard.flashcard.question)
                                    .font(.title3)
                                    .padding()
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("4A6572"))
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .background(Color("F5F5F5"))
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
                                    .background(
                                        LinearGradient(
                                            colors: [Color("4FC3F7"), Color("81D4FA")],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
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
                                .foregroundColor(Color("E57373"))
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Color("E57373").opacity(0.1))
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
                                .foregroundColor(Color("4FC3F7"))
                        }
                        .disabled(currentCardIndex == 0)
                        .opacity(currentCardIndex == 0 ? 0.5 : 1)
                        
                        Button(action: moveToNextCard) {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.title)
                                .foregroundColor(Color("4FC3F7"))
                        }
                        .disabled(currentCardIndex == favoriteCards.count - 1)
                        .opacity(currentCardIndex == favoriteCards.count - 1 ? 0.5 : 1)
                    }
                    .padding(.bottom)
                }
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