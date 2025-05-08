//
//  ASIS_CPP_FlashcardApp.swift
//  ASIS CPP Flashcard
//
//  Created by Shahab Geravesh on 1/22/25.
//

import SwiftUI

// MARK: - Shadow Style
struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    
    init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}

// MARK: - Design System
struct DesignSystem {
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let s: CGFloat = 8
        static let m: CGFloat = 16
        static let l: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
    }
    
    // MARK: - Shadow
    struct Shadow {
        static let small = ShadowStyle(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        static let medium = ShadowStyle(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        static let large = ShadowStyle(color: Color.black.opacity(0.15), radius: 16, x: 0, y: 8)
    }
    
    // MARK: - Animation
    struct Animation {
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.4)
    }
}

// MARK: - Color Theme
struct ColorTheme {
    // MARK: - Background Colors
    struct Background {
        /// Primary background gradient colors
        static func gradient(for colorScheme: ColorScheme) -> [Color] {
            colorScheme == .dark ? 
                [Color(hex: "1C1C1E"), Color(hex: "2C2C2E")] : // Dark mode: System dark colors
                [Color(hex: "F2F2F7"), Color(hex: "FFFFFF")]   // Light mode: System light colors
        }
        
        /// Card background colors
        static func card(for colorScheme: ColorScheme) -> Color {
            colorScheme == .dark ? Color(hex: "2C2C2E") : Color(hex: "FFFFFF")
        }
        
        /// List row background
        static func listRow(for colorScheme: ColorScheme) -> Color {
            colorScheme == .dark ? Color(hex: "2C2C2E") : Color(hex: "FFFFFF")
        }
    }
    
    // MARK: - Text Colors
    struct Text {
        /// Primary text color
        static let primary = Color(hex: "000000")  // System primary text
        
        /// Secondary text color
        static let secondary = Color(hex: "6C6C70")  // System secondary text
        
        /// Accent text color
        static let accent = Color(hex: "007AFF")  // System blue
    }
    
    // MARK: - Interactive Elements
    struct Interactive {
        /// Primary button gradient
        static let primaryGradient = LinearGradient(
            colors: [Color(hex: "007AFF"), Color(hex: "5856D6")],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        /// Success color (for correct answers, mastered cards)
        static let success = Color(hex: "34C759")  // System green
        
        /// Warning color (for incorrect answers, needs review)
        static let warning = Color(hex: "FF9500")  // System orange
        
        /// Error color
        static let error = Color(hex: "FF3B30")    // System red
        
        /// Favorite color
        static let favorite = Color(hex: "FF9500")  // System orange
    }
    
    // MARK: - Progress Indicators
    struct Progress {
        /// Progress bar background
        static let background = Color(hex: "E5E5EA")  // System gray 5
        
        /// Progress bar fill
        static let fill = Color(hex: "007AFF")        // System blue
        
        /// Progress bar gradient
        static let gradient = LinearGradient(
            colors: [Color(hex: "4FC3F7"), Color(hex: "81D4FA")],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    // MARK: - Card Elements
    struct Card {
        /// Card background gradient
        static let gradient = LinearGradient(
            colors: [Color(hex: "E3F2FD"), Color(hex: "BBDEFB")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        /// Card border gradient
        static let borderGradient = LinearGradient(
            colors: [
                Color(hex: "4FC3F7").opacity(0.3),
                Color(hex: "81D4FA").opacity(0.1)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Shadows
    struct Shadow {
        /// Card shadow
        static let card = Color.black.opacity(0.1)
        
        /// Button shadow
        static let button = Color.black.opacity(0.05)
    }
}

// MARK: - View Extensions
extension View {
    /// Applies the app's standard background gradient
    func appBackground() -> some View {
        self.modifier(AppBackgroundModifier())
    }
    
    /// Applies the app's standard card background
    func appCardBackground() -> some View {
        self.modifier(AppCardBackgroundModifier())
    }
    
    /// Applies the app's standard list row background
    func appListRowBackground() -> some View {
        self.modifier(AppListRowBackgroundModifier())
    }
    
    /// Applies the standard section header style
    func sectionHeaderStyle() -> some View {
        self
            .font(.system(size: 22, weight: .bold, design: .rounded))
            .foregroundColor(ColorTheme.Text.primary)
            .padding(.horizontal, DesignSystem.Spacing.m)
            .padding(.vertical, DesignSystem.Spacing.s)
    }
    
    /// Applies the standard card style
    func cardStyle() -> some View {
        self.modifier(CardStyleModifier())
    }
    
    /// Applies the standard button style
    func primaryButtonStyle() -> some View {
        self
            .padding(.horizontal, DesignSystem.Spacing.m)
            .padding(.vertical, DesignSystem.Spacing.s)
            .background(ColorTheme.Interactive.primaryGradient)
            .foregroundColor(.white)
            .cornerRadius(DesignSystem.CornerRadius.medium)
            .shadow(
                color: DesignSystem.Shadow.small.color,
                radius: DesignSystem.Shadow.small.radius,
                x: DesignSystem.Shadow.small.x,
                y: DesignSystem.Shadow.small.y
            )
    }
    
    /// Applies the secondary button style
    func secondaryButtonStyle() -> some View {
        self.modifier(SecondaryButtonStyleModifier())
    }
    
    /// Applies the standard list row style
    func listRowStyle() -> some View {
        self.modifier(ListRowStyleModifier())
    }
    
    /// Applies the standard title style
    func titleStyle() -> some View {
        self
            .font(.system(size: 28, weight: .bold, design: .rounded))
            .foregroundColor(ColorTheme.Text.primary)
            .padding(.horizontal, DesignSystem.Spacing.m)
            .padding(.vertical, DesignSystem.Spacing.s)
    }
    
    /// Applies the standard subtitle style
    func subtitleStyle() -> some View {
        self
            .font(.system(size: 20, weight: .semibold, design: .rounded))
            .foregroundColor(ColorTheme.Text.secondary)
            .padding(.horizontal, DesignSystem.Spacing.m)
            .padding(.vertical, DesignSystem.Spacing.xs)
    }
    
    /// Applies the standard body text style
    func bodyStyle() -> some View {
        self
            .font(.system(size: 16, weight: .regular, design: .rounded))
            .foregroundColor(ColorTheme.Text.primary)
            .padding(.horizontal, DesignSystem.Spacing.m)
            .padding(.vertical, DesignSystem.Spacing.xs)
    }
    
    /// Applies the standard caption style
    func captionStyle() -> some View {
        self
            .font(.system(size: 14, weight: .regular, design: .rounded))
            .foregroundColor(ColorTheme.Text.secondary)
            .padding(.horizontal, DesignSystem.Spacing.m)
            .padding(.vertical, DesignSystem.Spacing.xs)
    }
}

// MARK: - Style Modifiers
struct CardStyleModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(ColorTheme.Background.card(for: colorScheme))
            .cornerRadius(DesignSystem.CornerRadius.medium)
            .shadow(
                color: DesignSystem.Shadow.medium.color,
                radius: DesignSystem.Shadow.medium.radius,
                x: DesignSystem.Shadow.medium.x,
                y: DesignSystem.Shadow.medium.y
            )
    }
}

struct SecondaryButtonStyleModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, DesignSystem.Spacing.m)
            .padding(.vertical, DesignSystem.Spacing.s)
            .background(ColorTheme.Background.card(for: colorScheme))
            .foregroundColor(ColorTheme.Text.primary)
            .cornerRadius(DesignSystem.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .stroke(ColorTheme.Text.secondary.opacity(0.2), lineWidth: 1)
            )
    }
}

struct ListRowStyleModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical, DesignSystem.Spacing.s)
            .padding(.horizontal, DesignSystem.Spacing.m)
            .background(ColorTheme.Background.listRow(for: colorScheme))
    }
}

// MARK: - View Modifiers
struct AppBackgroundModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content.background(
            LinearGradient(
                colors: ColorTheme.Background.gradient(for: colorScheme),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

struct AppCardBackgroundModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content.background(ColorTheme.Background.card(for: colorScheme))
    }
}

struct AppListRowBackgroundModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content.listRowBackground(ColorTheme.Background.listRow(for: colorScheme))
    }
}

// MARK: - Color Extensions
extension Color {
    /// Creates a color from a hex string
    init(hex: String) {
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
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

@main
struct ASIS_CPP_FlashcardApp: App {
    @StateObject private var chapterStore = ChapterStore()
    @ObservedObject private var settings = UserSettings.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(chapterStore)
                .preferredColorScheme(settings.isDarkMode ? .dark : .light)
        }
    }
}
