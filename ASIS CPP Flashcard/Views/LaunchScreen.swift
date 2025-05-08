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
                
                Text("ASIS CPP")
                    .font(.system(size: 32, weight: .bold))
                
                Text("Flashcards")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
} 