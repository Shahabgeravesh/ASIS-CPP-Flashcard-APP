import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "book.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Certified Protection Professional")
                    .font(.system(size: 32, weight: .bold))
                
                Text("CPP")
                    .font(.system(size: 28, weight: .semibold))
                
                Text("Flashcards")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
    }
} 