//
//  ASIS_CPP_FlashcardApp.swift
//  ASIS CPP Flashcard
//
//  Created by Shahab Geravesh on 1/22/25.
//

import SwiftUI

// MARK: - Color Theme
struct ColorTheme {
    // MARK: - Background Colors
    struct Background {
        /// Primary background gradient colors
        static func gradient(for colorScheme: ColorScheme) -> [Color] {
            colorScheme == .dark ? 
                [Color(hex: "1A1A1A"), Color(hex: "2A2A2A")] : // Dark mode: Deep, comfortable dark gradient
                [Color(hex: "E3F2FD"), Color(hex: "BBDEFB")]   // Light mode: Soft, calming blue gradient
        }
        
        /// Card background colors
        static func card(for colorScheme: ColorScheme) -> Color {
            colorScheme == .dark ? Color(hex: "1A1A1A") : Color(hex: "F5F5F5")
        }
        
        /// List row background
        static func listRow(for colorScheme: ColorScheme) -> Color {
            colorScheme == .dark ? Color(hex: "1A1A1A") : Color(hex: "F5F5F5")
        }
    }
    
    // MARK: - Text Colors
    struct Text {
        /// Primary text color
        static let primary = Color(hex: "4A6572")  // Deep blue-gray, easy on the eyes
        
        /// Secondary text color
        static let secondary = Color(hex: "6B8C9A")  // Lighter blue-gray for less emphasis
        
        /// Accent text color
        static let accent = Color(hex: "4FC3F7")  // Bright blue for emphasis
    }
    
    // MARK: - Interactive Elements
    struct Interactive {
        /// Primary button gradient
        static let primaryGradient = LinearGradient(
            colors: [Color(hex: "4FC3F7"), Color(hex: "81D4FA")],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        /// Success color (for correct answers, mastered cards)
        static let success = Color(hex: "81C784")  // Soft green
        
        /// Warning color (for incorrect answers, needs review)
        static let warning = Color(hex: "E57373")  // Soft red
        
        /// Favorite color
        static let favorite = Color(hex: "FFD54F")  // Warm yellow
    }
    
    // MARK: - Progress Indicators
    struct Progress {
        /// Progress bar background
        static let background = Color(hex: "5D7B89").opacity(0.1)
        
        /// Progress bar fill
        static let fill = Color(hex: "5D7B89")
        
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
