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
    
    // Calm-inspired color scheme
    private let cardGradient = LinearGradient(
        colors: [
            Color("E3F2FD"),
            Color("BBDEFB")
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    private let buttonGradient = LinearGradient(
        colors: [
            Color("4FC3F7"),
            Color("81D4FA")
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    var body: some View {
        ZStack {
            // Sky-inspired background
            Color("E3F2FD")
                .ignoresSafeArea()
            
            VStack {
                if isVisible {
                    ZStack {
                        // Background indicators for swipe direction
                        HStack {
                            // Left swipe indicator
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color("E57373").opacity(0.15))
                                .overlay(
                                    Image(systemName: "arrow.counterclockwise")
                                        .font(.system(size: 30))
                                        .foregroundColor(Color("E57373"))
                                )
                                .opacity(offset.width < 0 ? Double(-offset.width/100) : 0)
                            
                            // Right swipe indicator
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color("81C784").opacity(0.15))
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 30))
                                        .foregroundColor(Color("81C784"))
                                )
                                .opacity(offset.width > 0 ? Double(offset.width/100) : 0)
                        }
                        
                        // Front of card
                        VStack(spacing: 20) {
                            // Add favorite button at the top
                            if let onFavoriteToggle = onFavoriteToggle {
                                HStack {
                                    Button(action: onFavoriteToggle) {
                                        Image(systemName: flashcard.isFavorite ? "star.fill" : "star")
                                            .foregroundColor(Color("FFD54F"))
                                            .font(.system(size: 24))
                                    }
                                    .padding(.leading)
                                    
                                    Spacer()
                                }
                            }
                            
                            Text(flashcard.question)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("4A6572"))
                                .padding(.horizontal)
                                .padding(.top)
                                .multilineTextAlignment(.center)
                            
                            Button(action: flipCard) {
                                Text("Show Answer")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(buttonGradient)
                                    .cornerRadius(15)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            }
                            .padding(.bottom)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .background(cardGradient)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .opacity(isFlipped ? 0 : 1)
                        
                        // Back of card
                        VStack(spacing: 20) {
                            // Add favorite button at the top of the back side too
                            if let onFavoriteToggle = onFavoriteToggle {
                                HStack {
                                    Button(action: onFavoriteToggle) {
                                        Image(systemName: flashcard.isFavorite ? "star.fill" : "star")
                                            .foregroundColor(Color("FFD54F"))
                                            .font(.system(size: 24))
                                    }
                                    .padding(.leading)
                                    
                                    Spacer()
                                }
                            }
                            
                            ScrollView {
                                Text(flashcard.answer)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("4A6572"))
                                    .padding(.horizontal)
                                    .padding(.top)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            
                            Button(action: flipCard) {
                                Text("Show Question")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(buttonGradient)
                                    .cornerRadius(15)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            }
                            .padding(.bottom)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .background(cardGradient)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .opacity(isFlipped ? 1 : 0)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
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
                    
                    // Modern swipe instructions
                    HStack(spacing: 20) {
                        HStack(spacing: 10) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color("E57373").opacity(0.12))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "arrow.left")
                                    .foregroundColor(Color("E57373"))
                                    .font(.system(size: 22, weight: .bold))
                            }
                            Text("Didn't know?\nSwipe left")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(Color("E57373"))
                                .multilineTextAlignment(.leading)
                        }
                        Spacer(minLength: 24)
                        HStack(spacing: 10) {
                            Text("Knew it!\nSwipe right")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(Color("81C784"))
                                .multilineTextAlignment(.trailing)
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color("81C784").opacity(0.12))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "arrow.right")
                                    .foregroundColor(Color("81C784"))
                                    .font(.system(size: 22, weight: .bold))
                            }
                        }
                    }
                    .padding(.top, 18)
                    .padding(.horizontal, 16)
                    .background(Color("F5F5F5").opacity(0.7))
                    .cornerRadius(18)
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
                }
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

// Color extension for hex colors
extension Color {
    init(_ hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 