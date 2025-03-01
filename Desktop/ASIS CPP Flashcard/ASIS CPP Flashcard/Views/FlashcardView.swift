import SwiftUI

struct FlashcardView: View {
    let flashcard: Flashcard
    @Binding var showingAnswer: Bool
    var onAnswerViewed: () -> Void
    var onSwipeLeft: () -> Void
    var onSwipeRight: () -> Void
    @Binding var offset: CGSize
    var onFavoriteToggle: (() -> Void)?
    
    @State private var rotation = 0.0
    @State private var isDragging = false
    @State private var opacity = 1.0
    @State private var isVisible = true
    @State private var isFlipped = false
    @State private var swipeDirection: SwipeDirection? = nil
    
    private enum SwipeDirection {
        case left, right
    }
    
    var body: some View {
        VStack {
            if isVisible {
                ZStack {
                    // Background indicators for swipe direction
                    HStack {
                        // Left swipe indicator
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.red.opacity(0.3))
                            .overlay(
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.system(size: 30))
                                    .foregroundColor(.red)
                            )
                            .opacity(offset.width < 0 ? Double(-offset.width/100) : 0)
                        
                        // Right swipe indicator
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.green.opacity(0.3))
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.system(size: 30))
                                    .foregroundColor(.green)
                            )
                            .opacity(offset.width > 0 ? Double(offset.width/100) : 0)
                    }
                    
                    // Front of card
                    ZStack {
                        // Front of card (Question)
                        VStack(spacing: 20) {
                            // Favorite button
                            if let onFavoriteToggle = onFavoriteToggle {
                                HStack {
                                    Button(action: onFavoriteToggle) {
                                        Image(systemName: flashcard.isFavorite ? "star.fill" : "star")
                                            .foregroundColor(.yellow)
                                            .font(.system(size: 24))
                                    }
                                    .padding(.leading)
                                    
                                    Spacer()
                                }
                            }
                            
                            ScrollView {
                                Text(flashcard.question)
                                    .font(.title3)
                                    .padding(.horizontal)
                                    .padding(.top)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .frame(maxHeight: UIScreen.main.bounds.height * 0.4)
                            
                            Button(action: flipCard) {
                                Text("Show Answer")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(Color.blue)
                                    .cornerRadius(15)
                            }
                            .padding(.bottom)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .opacity(isFlipped ? 0 : 1)
                        
                        // Back of card (Answer)
                        VStack(spacing: 20) {
                            if let onFavoriteToggle = onFavoriteToggle {
                                HStack {
                                    Button(action: onFavoriteToggle) {
                                        Image(systemName: flashcard.isFavorite ? "star.fill" : "star")
                                            .foregroundColor(.yellow)
                                            .font(.system(size: 24))
                                    }
                                    .padding(.leading)
                                    
                                    Spacer()
                                }
                            }
                            
                            ScrollView {
                                Text(flashcard.answer)
                                    .font(.title3)
                                    .padding(.horizontal)
                                    .padding(.top)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .frame(maxHeight: UIScreen.main.bounds.height * 0.4)
                            
                            Button(action: flipCard) {
                                Text("Show Question")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(Color.blue)
                                    .cornerRadius(15)
                            }
                            .padding(.bottom)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .opacity(isFlipped ? 1 : 0)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    }
                }
                .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
                .padding()
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            isDragging = true
                            offset = gesture.translation
                        }
                        .onEnded { gesture in
                            isDragging = false
                            handleSwipe(gesture: gesture)
                        }
                )
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: offset)
            }
        }
    }
    
    private func handleSwipe(gesture: DragGesture.Value) {
        let threshold: CGFloat = 100
        let horizontalAmount = gesture.translation.width
        
        if abs(horizontalAmount) > threshold {
            let screenWidth = UIScreen.main.bounds.width
            if horizontalAmount > 0 {
                // Swipe right - Mark as mastered
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    offset.width = screenWidth * 1.5
                    swipeDirection = .right
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onSwipeRight()
                    resetCard()
                }
            } else {
                // Swipe left - Mark for review
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    offset.width = -screenWidth * 1.5
                    swipeDirection = .left
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onSwipeLeft()
                    resetCard()
                }
            }
        } else {
            resetCard()
        }
    }
    
    private func resetCard() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            offset = .zero
            swipeDirection = nil
            isFlipped = false
            rotation = 0
            showingAnswer = false
        }
    }
    
    private func flipCard() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            isFlipped.toggle()
            rotation += 180
            showingAnswer.toggle()
            
            if showingAnswer {
                onAnswerViewed()
            }
        }
    }
} 