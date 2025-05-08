import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        ZStack {
            // Modern gradient background
            LinearGradient(
                colors: [
                    Color("E3F2FD"),
                    Color("BBDEFB"),
                    Color("90CAF9")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "book.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color("4FC3F7"), Color("81D4FA")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color("4FC3F7").opacity(0.3), radius: 10, x: 0, y: 5)
                
                Text("ASIS CPP")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color("4A6572"))
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                
                Text("Flashcards")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(Color("6B8C9A"))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.9))
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