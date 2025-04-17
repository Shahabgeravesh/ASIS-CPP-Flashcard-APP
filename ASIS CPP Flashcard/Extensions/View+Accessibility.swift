import SwiftUI

extension View {
    func addAccessibility(label: String, hint: String) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint)
    }
} 