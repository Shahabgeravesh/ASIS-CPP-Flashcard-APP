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
    
    @Environment(\.colorScheme) var colorScheme
    
    private enum SwipeDirection {
        case left, right
    }
    
    // Modern color scheme using system colors
    private let cardGradient = LinearGradient(
        colors: [
            ColorTheme.Background.card(for: .light),
            ColorTheme.Background.card(for: .light).opacity(0.95)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    private let buttonGradient = ColorTheme.Interactive.primaryGradient
    
    var body: some View {
        ZStack {
            // System background
            LinearGradient(
                colors: ColorTheme.Background.gradient(for: colorScheme),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                if isVisible {
                    ZStack {
                        // Background indicators for swipe direction
                        HStack {
                            // Left swipe indicator
                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                .fill(ColorTheme.Interactive.error.opacity(0.15))
                                .overlay(
                                    Image(systemName: "arrow.counterclockwise")
                                        .font(.system(size: 30, weight: .medium))
                                        .foregroundColor(ColorTheme.Interactive.error)
                                )
                                .opacity(offset.width < 0 ? Double(-offset.width/100) : 0)
                            
                            // Right swipe indicator
                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                .fill(ColorTheme.Interactive.success.opacity(0.15))
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 30, weight: .medium))
                                        .foregroundColor(ColorTheme.Interactive.success)
                                )
                                .opacity(offset.width > 0 ? Double(offset.width/100) : 0)
                        }
                        
                        // Front of card
                        VStack(spacing: DesignSystem.Spacing.m) {
                            Spacer()
                            
                            Text(flashcard.question)
                                .font(.system(size: 24, weight: .semibold, design: .rounded))
                                .foregroundColor(ColorTheme.Text.primary)
                                .padding(.horizontal, DesignSystem.Spacing.l)
                                .padding(.vertical, DesignSystem.Spacing.m)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Spacer()
                            
                            VStack(spacing: DesignSystem.Spacing.m) {
                                Button(action: flipCard) {
                                    Text("Show Answer")
                                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, DesignSystem.Spacing.l)
                                        .padding(.vertical, DesignSystem.Spacing.s)
                                        .background(buttonGradient)
                                        .cornerRadius(DesignSystem.CornerRadius.medium)
                                        .shadow(
                                            color: DesignSystem.Shadow.small.color,
                                            radius: DesignSystem.Shadow.small.radius,
                                            x: DesignSystem.Shadow.small.x,
                                            y: DesignSystem.Shadow.small.y
                                        )
                                }
                                
                                // Add favorite button under Show Answer
                                if let onFavoriteToggle = onFavoriteToggle {
                                    Button(action: onFavoriteToggle) {
                                        Image(systemName: flashcard.isFavorite ? "star.fill" : "star")
                                            .foregroundColor(ColorTheme.Interactive.favorite)
                                            .font(.system(size: 24, weight: .medium))
                                    }
                                }
                            }
                            .padding(.bottom, DesignSystem.Spacing.l)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 400)
                        .background(cardGradient)
                        .cornerRadius(DesignSystem.CornerRadius.large)
                        .shadow(
                            color: DesignSystem.Shadow.medium.color,
                            radius: DesignSystem.Shadow.medium.radius,
                            x: DesignSystem.Shadow.medium.x,
                            y: DesignSystem.Shadow.medium.y
                        )
                        .opacity(isFlipped ? 0 : 1)
                        
                        // Back of card
                        VStack(spacing: DesignSystem.Spacing.m) {
                            Spacer()
                            
                            ScrollView {
                                Text(flashcard.answer)
                                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                                    .foregroundColor(ColorTheme.Text.primary)
                                    .padding(.horizontal, DesignSystem.Spacing.l)
                                    .padding(.vertical, DesignSystem.Spacing.m)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            
                            Spacer()
                            
                            VStack(spacing: DesignSystem.Spacing.m) {
                                Button(action: flipCard) {
                                    Text("Show Question")
                                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, DesignSystem.Spacing.l)
                                        .padding(.vertical, DesignSystem.Spacing.s)
                                        .background(buttonGradient)
                                        .cornerRadius(DesignSystem.CornerRadius.medium)
                                        .shadow(
                                            color: DesignSystem.Shadow.small.color,
                                            radius: DesignSystem.Shadow.small.radius,
                                            x: DesignSystem.Shadow.small.x,
                                            y: DesignSystem.Shadow.small.y
                                        )
                                }
                                
                                // Add favorite button under Show Question
                                if let onFavoriteToggle = onFavoriteToggle {
                                    Button(action: onFavoriteToggle) {
                                        Image(systemName: flashcard.isFavorite ? "star.fill" : "star")
                                            .foregroundColor(ColorTheme.Interactive.favorite)
                                            .font(.system(size: 24, weight: .medium))
                                    }
                                }
                            }
                            .padding(.bottom, DesignSystem.Spacing.l)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 500)
                        .background(cardGradient)
                        .cornerRadius(DesignSystem.CornerRadius.large)
                        .shadow(
                            color: DesignSystem.Shadow.medium.color,
                            radius: DesignSystem.Shadow.medium.radius,
                            x: DesignSystem.Shadow.medium.x,
                            y: DesignSystem.Shadow.medium.y
                        )
                        .opacity(isFlipped ? 1 : 0)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    }
                    .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
                    .padding(DesignSystem.Spacing.m)
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
                    HStack(spacing: DesignSystem.Spacing.m) {
                        HStack(spacing: DesignSystem.Spacing.s) {
                            ZStack {
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                    .fill(ColorTheme.Interactive.error.opacity(0.12))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "arrow.left")
                                    .foregroundColor(ColorTheme.Interactive.error)
                                    .font(.system(size: 22, weight: .semibold))
                            }
                            Text("Didn't know?\nSwipe left")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(ColorTheme.Interactive.error)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: DesignSystem.Spacing.s) {
                            Text("Knew it?\nSwipe right")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(ColorTheme.Interactive.success)
                            ZStack {
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                    .fill(ColorTheme.Interactive.success.opacity(0.12))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "arrow.right")
                                    .foregroundColor(ColorTheme.Interactive.success)
                                    .font(.system(size: 22, weight: .semibold))
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.m)
                    .padding(.top, DesignSystem.Spacing.m)
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