import SwiftUI

struct LaunchScreen: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // System background
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "book.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(Color(.systemBlue))
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                Text("ASIS CPP")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(Color(.label))
                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
                
                Text("Flashcards")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(Color(.secondaryLabel))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
            )
            .padding()
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
} 