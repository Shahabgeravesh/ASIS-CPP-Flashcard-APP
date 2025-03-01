import SwiftUI

enum AppTheme {
    // Colors
    static let primary = Color("AccentColor")
    static let secondary = Color(.systemIndigo)
    static let accent = Color(.systemTeal)
    static let success = Color(.systemGreen)
    
    // Typography
    static let titleFont = Font.system(.title, design: .rounded).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded).weight(.bold)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded).weight(.medium)
    
    // Card Style
    static let cardBackground = Color(.systemBackground)
    static let cardShadow = Color.black.opacity(0.1)
    static let cardCornerRadius: CGFloat = 16
    static let cardPadding: CGFloat = 20
} 